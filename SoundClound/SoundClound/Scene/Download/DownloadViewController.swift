//
//  DownloadViewController.swift
//  SoundClound
//
//  Created by Hai on 7/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

final class DownloadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var trackList: [TrackInfo]?
    fileprivate struct Constants {
        static let downloadTrackHeight = 100
        static let rows = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: DownloadTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trackList = DatabaseManager.getTracks()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trackList = trackList else { return 0 }
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let trackList = trackList else { return UITableViewCell() }
        let track = trackList[indexPath.row] 
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DownloadTableViewCell.self)
        cell.setContentForDownloadCell(track: track)
        return cell
    }
}

extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.downloadTrackHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let playerViewController = PlayerViewController.instantiate()
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        guard let playerViewController = storyBroad.instantiateViewController(withIdentifier: "Player") as? PlayerViewController else { return }
        guard let trackList = trackList else { return }
        let track = trackList[indexPath.row]
        OfflineChecker.isOffline = true
        playerViewController.track = track
        playerViewController.currentIndexPath = indexPath
        playerViewController.trackList?.removeAll()
        playerViewController.trackList = DatabaseManager.getTracks()
        playerViewController.tabBarSelectedIndex = self.tabBarController?.selectedIndex
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
}
