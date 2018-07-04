//
//  SearchTableViewCell.swift
//  SoundClound
//
//  Created by Hai on 7/4/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

class SearchTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackTitle: UILabel!
    @IBOutlet private weak var trackDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setContentForSearchCell(track: TrackModel) {
        self.trackTitle.text = track.title
        self.trackDescription.text = track.description
        let trackImage = track.image
        let url = URL(string: trackImage)
        self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
        
    }
}
