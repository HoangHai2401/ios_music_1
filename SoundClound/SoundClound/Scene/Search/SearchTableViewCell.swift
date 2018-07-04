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

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setContentForSearchCell(track: TrackInfo){
        self.trackTitle.text = track.trackModel?.title
        self.trackDescription.text = track.trackModel?.description
        if let trackImage = track.trackModel?.image {
            let url = URL(string: trackImage)
            self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
        }
    }
}
