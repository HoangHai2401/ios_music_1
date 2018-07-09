//
//  DownloadTableViewCell.swift
//  SoundClound
//
//  Created by Hai on 7/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

class DownloadTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackTitle: UILabel!
    @IBOutlet private weak var trackDescription: UILabel!
    @IBOutlet private weak var downloadStatus: UILabel!
    @IBOutlet private weak var downloadStatusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForDownloadCell(track: TrackInfo) {
        self.trackTitle.text = track.trackModel?.title
        self.trackDescription.text = track.trackModel?.description
        guard let trackImage = track.trackModel?.image else { return }
        let url = URL(string: trackImage)
        self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
    }
}

