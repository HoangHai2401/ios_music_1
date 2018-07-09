//
//  PlayerViewController.swift
//  SoundClound
//
//  Created by Hai on 6/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import AVFoundation
import Reusable

final class PlayerViewController: UIViewController, StoryboardSceneBased {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var playerView: PlayerView!
    
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var track: TrackInfo? {
        didSet {
            playerView?.track = track
        }
    }

    var genre: GenreModel?
    var currentIndexPath: IndexPath?
    fileprivate var genreRepository: GenreRepository!
    var trackList: [TrackInfo]?
    var tabBarSelectedIndex: Int?
    
    private struct Constant {
        static let playerCellHeight = 350
        static let relatedTrackCellHeight = 100
        static let numberOfDisplayingTrack = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let selectedIndex = tabBarSelectedIndex else { return }
        print(selectedIndex)
        switch selectedIndex {
        case 2:
            OfflineChecker.isOffline = true
        default:
            OfflineChecker.isOffline = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView?.track = track
        
        nextTrackAction()
        previousTrackAction()
        nextShuffleTrackAction()
        playBackAction()
        loopAllAction()
        setTableView()
        setNavigationItem()
    }
    
    private func setNavigationItem() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back",
                                            style: UIBarButtonItemStyle.plain,
                                            target: self, action: #selector(back(sender:)))
        newBackButton.tintColor = UIColor.orange
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func back(sender: UIBarButtonItem) {
        self.playerView.timer?.invalidate()
        navigationController?.popViewController(animated: true)
    }
    
    private func setTableView() {
        tableView.register(cellType: RelatedTrackTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func loopAllAction() {
        playerView.loopAll = { [weak playerView, weak self] in
            guard let `self` = self else { return }
            if let currentIndexPath = self.currentIndexPath,
                let trackList = self.trackList {
                let trackCount = trackList.count
                if currentIndexPath.row == trackCount - 1 {
                    let track = trackList[0]
                    self.currentIndexPath = IndexPath(row: 0, section: 0)
                    playerView?.track = track
                }
            }
        }
    }
    
    private func playBackAction() {
        playerView.playBack = { [weak playerView, weak self] in
            guard let `self` = self else { return }
            if let currentIndexPath = self.currentIndexPath,
                let trackList = self.trackList {
                let trackCount = trackList.count
                if currentIndexPath.row < trackCount - 1 {
                    let track = trackList[currentIndexPath.row]
                    playerView?.track = track
                }
            }
        }
    }
    
    private func nextShuffleTrackAction() {
        playerView.nextShuffleTrack = { [weak playerView, weak self] in
            guard let `self` = self else { return }
            var nextIndexPath = IndexPath()
            if let currentIndexPath = self.currentIndexPath,
                let trackList = self.trackList {
                let trackCount = trackList.count
                if currentIndexPath.row < trackCount {
                    repeat {
                        let randomTrack = Int(arc4random_uniform(UInt32(trackCount)))
                        nextIndexPath = IndexPath(row: randomTrack, section: 0)
                    } while nextIndexPath.row == currentIndexPath.row
                    self.currentIndexPath = nextIndexPath
                    let track = trackList[nextIndexPath.row]
                    playerView?.track = track
                }
            }
        }
    }
    
    private func nextTrackAction() {
        playerView.nextTrack = { [weak playerView, weak self] in
            guard let `self` = self else { return }
            if let currentIndexPath = self.currentIndexPath,
                let trackList = self.trackList {
                let trackCount = trackList.count
                if currentIndexPath.row < trackCount - 1 {
                    let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: 0)
                    self.currentIndexPath = nextIndexPath
                    let track = trackList[nextIndexPath.row]
                    playerView?.track = track
                }
            }
        }
    }
    
    private func previousTrackAction() {
        playerView.previousTrack = { [weak playerView, weak self] in
            guard let `self` = self else { return }
            if let currentIndexPath = self.currentIndexPath,
                let trackList = self.trackList {
                if currentIndexPath.row > 0 {
                    let previousIndexPath = IndexPath(row: currentIndexPath.row - 1, section: 0)
                    self.currentIndexPath = previousIndexPath
                    let track = trackList[previousIndexPath.row]
                    playerView?.track = track
                }
            }
        }
    }
    
    private func getTracks(for genre: GenreModel) {
        genreRepository.getGenre(kind: genre.kind.rawValue, genre: genre.type.query, limit: Constant.numberOfDisplayingTrack, linkedPartitioning: 1) { [weak self] (result) in
            switch result {
            case .success(let value):
                genre.tracks = value.tracks
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                self?.trackList = genre.tracks
            case .failure(let error):
                self?.showError(message: error?.localizedDescription ?? "")
            }
        }
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trackCount = trackList?.count else { return 0 }
        return trackCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RelatedTrackTableViewCell.self)
        guard let trackList = trackList else { return UITableViewCell() }
        let track = trackList[indexPath.row]
        cell.setContentForRelatedTrackCell(track: track)
        return cell
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constant.relatedTrackCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let trackList = trackList else { return }
        let track = trackList[indexPath.row]
        self.track = track
        currentIndexPath = indexPath
    }
}
