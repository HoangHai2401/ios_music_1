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

private struct parameter {
    static let tableViewCellHeight = 280
    static let collectionViewCellWidth = 120
    static let collectionViewCellHeight = 190
}

final class HomeViewController: UIViewController {

    var storedOffsets = [Int: CGFloat]()
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let genreRepository: GenreRepository = GenreRepositoryImpl(api: APIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: HomeGenreCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        //test fetching data
        genreRepository.getGenre(kind: "trending", genre: "soundcloud:genres:all-music", limit: 10, linkedPartitioning: 1) {(result) in switch result{
        case .success(let trackCollection):
            print(trackCollection?.genre! as Any)
            print(trackCollection?.kind! as Any)
            if let trackList = trackCollection?.trackList{
                for trackList in trackList{
                    print(trackList.trackModel?.title! as Any)
                    print(trackList.trackModel?.description! as Any)
                }
            }
        case .failure:
            print("Fail to retrieve data")
            }}
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
        return CGFloat(parameter.tableViewCellHeight)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.genre.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HomeGenreCell.self)
        cell.setContentForTableViewCell(genre: songs.genre[indexPath.row], description: "description")
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return songs.songname.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeSongCell.self)
        cell.setContentForCollectionViewCell(name: songs.songname[indexPath.row], description: "description")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: parameter.collectionViewCellWidth, height: parameter.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

