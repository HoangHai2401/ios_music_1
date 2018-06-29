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

final class PlayerViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var playerView: PlayerView!
    
    var track: TrackInfo? {
        didSet {
            playerView?.track = track
        }
    }

    var genre: GenreModel?
    var currentIndexPath: IndexPath?
    fileprivate var genreRepository: GenreRepository!
    
    private struct Constant {
        static let playerCellHeight = 350
        static let relatedTrackCellHeight = 100
        static let numberOfDisplayingTrack = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView?.track = track
        
        nextTrackAction()
        previousTrackAction()
        setTableView()
        
        genreRepository = GenreRepositoryImpl(api: APIService.share)
        guard let genre = genre else { return }
        getTracks(for: genre)
    }
    
    private func setTableView() {
        tableView.register(cellType: RelatedTrackTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func nextTrackAction() {
        playerView.nextTrack = { [weak playerView, weak self] in
            if let currentIndexPath = self?.currentIndexPath,
                let genre = self?.genre {
                let trackCount = genre.tracks.count
                if currentIndexPath.row < trackCount - 1 {
                    let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: 0)
                    self?.currentIndexPath = nextIndexPath
                    let track = genre.tracks[nextIndexPath.row]
                    playerView?.track = track
                }
            }
        }
    }
    
    private func previousTrackAction() {
        playerView.previousTrack = { [weak playerView, weak self] in
            if let currentIndexPath = self?.currentIndexPath,
                let genre = self?.genre {
                let trackCount = genre.tracks.count
                if currentIndexPath.row > 0 {
                    let previousIndexPath = IndexPath(row: currentIndexPath.row - 1, section: 0)
                    self?.currentIndexPath = previousIndexPath
                    let track = genre.tracks[previousIndexPath.row]
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
                //                if genre.tracks.index(where: {$0.trackModel?.id == removeTrack.trackModel?.id})
                //                    .map({ genre.tracks.remove(at: $0)}) != nil {}
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.showError(message: error?.localizedDescription ?? "")
            }
        }
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genre?.tracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RelatedTrackTableViewCell.self)
        if let track = genre?.tracks[indexPath.row] {
            cell.setContentForRelatedTrackCell(track: track)
        }
        return cell
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constant.relatedTrackCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = genre?.tracks[indexPath.row]
        self.track = track
        currentIndexPath = indexPath
    }
}
