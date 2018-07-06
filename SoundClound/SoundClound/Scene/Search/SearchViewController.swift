//
//  SearchViewController.swift
//  SoundClound
//
//  Created by Hai on 7/4/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import Alamofire
import AVFoundation

final class SearchViewController: UIViewController, UITextFieldDelegate {
    fileprivate var searchRepository: SearchRepository!
    fileprivate var trackList = SearchModel()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate struct Constants {
        static let searchTrackHeight = 100
        static let rows = 10
        static let limit = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchRepository = SearchRepositoryImpl(api: APIService.share)
        getTracks(for: trackList)
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: SearchTableViewCell.self)
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchRecord(_:)), for: .editingChanged)
    }
    
    @objc func searchRecord(_ textField: UITextField) {
        self.trackList.tracks.removeAll()
        getTracks(for: trackList)
    }
    
    private func getTracks(for key: SearchModel) {
        guard let searchKey = searchTextField.text else { return }
        searchRepository.getResult(key: searchKey, limit: Constants.limit, linkedpartitioning: 1)
        { [weak self] (result) in
            switch result {
            case .success(let value):
                key.tracks = value.tracks
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.showError(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackList.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchTableViewCell.self)
        cell.setContentForSearchCell(track: trackList.tracks[indexPath.row])
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.searchTrackHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        guard let playerViewController = storyBroad.instantiateViewController(withIdentifier: "Player") as? PlayerViewController else { return }
        let trackList = self.trackList
        var trackInfoList = [TrackInfo]()
        for track in trackList.tracks {
            let trackInfo = TrackInfo(track: track)
            trackInfoList.append(trackInfo)
        }
        let trackToPass = trackList.tracks[indexPath.row]
        let trackInfoToPass = TrackInfo(track: trackToPass)
        OfflineChecker.isOffline = false
        playerViewController.track = trackInfoToPass
        playerViewController.currentIndexPath = indexPath
        playerViewController.trackList?.removeAll()
        playerViewController.trackList = trackInfoList
        playerViewController.tabBarSelectedIndex = self.tabBarController?.selectedIndex
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
}
