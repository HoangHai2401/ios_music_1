//
//  HomeSongCell.swift
//  SoundClound
//
//  Created by Hai on 6/20/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage
import MarqueeLabel

final class HomeSongCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    
    func setContentForCollectionViewCell(track: TrackInfo){
        self.nameLabel.text = track.trackModel?.title
        self.descriptionLabel.text = track.trackModel?.description
        if let image = track.trackModel?.image {
            let url = URL(string: image)
            self.songImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
