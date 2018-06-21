//
//  HomeGenreCell.swift
//  SoundClound
//
//  Created by Hai on 6/20/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

final class HomeGenreCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    func setContentForTableViewCell(genre: String, description: String){
        self.genreLabel.text = genre
        self.descriptionLabel.text = description
    }

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(cellType: HomeSongCell.self)
    }
}
