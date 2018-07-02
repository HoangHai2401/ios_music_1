//
//  HomeViewController.swift
//  SoundClound
//
//  Created by Hai on 6/20/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import Alamofire
import AVFoundation

final class HomeViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    private struct Constant {
        static let tableViewCellHeight = 310
        static let collectionViewCellWidth = 120
        static let collectionViewCellHeight = 190
    }
    
    fileprivate var storedOffsets = [Int: CGFloat]()
    fileprivate var genres = [GenreModel]()
    
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var genreRepository: GenreRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: HomeGenreCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        genreRepository = GenreRepositoryImpl(api: APIService.share)
        genres = [
            GenreModel(type: .allMusic, kind: .top),
            GenreModel(type: .allAudio, kind: .trending),
            GenreModel(type: .alternativeRock, kind: .trending),
            GenreModel(type: .ambient, kind: .trending),
            GenreModel(type: .classical, kind: .trending),
            GenreModel(type: .country, kind: .trending),
        ]
        getData()
    }
    
    private func getData() {
        for genre in genres {
            getTracks(for: genre)
        }
    }
    
    private func getTracks(for genre: GenreModel) {
        genreRepository.getGenre(kind: genre.kind.rawValue, genre: genre.type.query, limit: 15, linkedPartitioning: 1) { [weak self] (result) in
            switch result {
            case .success(let value):
                genre.tracks = value.tracks
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.showError(message: error?.localizedDescription ?? "")
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeGenreCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeGenreCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constant.tableViewCellHeight)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HomeGenreCell.self)
        //TableView Cell Display
        let genre = genres[indexPath.row]
        cell.setContentForTableViewCell(genre: genre)
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let row = collectionView.tag
        let genre = genres[row]
        return genre.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeSongCell.self)
        //CollectionView Cell Display
        let row = collectionView.tag
        let genre = genres[row]
        let track = genre.tracks[indexPath.row]
        cell.setContentForCollectionViewCell(track: track)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.collectionViewCellWidth, height: Constant.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        guard let playerViewController = storyBroad.instantiateViewController(withIdentifier: "Player") as? PlayerViewController else { return }
        
        let row = collectionView.tag
        let genre = genres[row]
        let track = genre.tracks[indexPath.row]
        let relatedGenre = genre
        playerViewController.genre = relatedGenre
        playerViewController.track = track
        playerViewController.currentIndexPath = indexPath
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
}
