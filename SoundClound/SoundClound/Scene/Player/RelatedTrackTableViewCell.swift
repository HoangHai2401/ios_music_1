//
//  RelatedTrackTableViewCell.swift
//  SoundClound
//
//  Created by Hai on 6/27/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import MarqueeLabel
import SDWebImage

class RelatedTrackTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackTitleLabel: MarqueeLabel!
    @IBOutlet private weak var trackDescriptionLabel: MarqueeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForRelatedTrackCell(track: TrackInfo) {
        self.trackTitleLabel.text = track.trackModel?.title
        self.trackDescriptionLabel.text = track.trackModel?.description
        self.trackImage.image = #imageLiteral(resourceName: "SongImage2")
        if let trackImage = track.trackModel?.image {
            let url = URL(string: trackImage)
            self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
        }
    }
}
