//
//  PlayerCellTableViewCell.swift
//  SoundClound
//
//  Created by Hai on 6/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

class PlayerTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackBackgroundImage: UIImageView!
    @IBOutlet private weak var trackTitleLabel: UILabel!
    @IBOutlet private weak var trackDescriptionLabel: UILabel!
    @IBOutlet private weak var progressBar: NSLayoutConstraint!
    @IBOutlet private weak var durationLeftLabel: UILabel!
    @IBOutlet private weak var durationMaxLabel: UILabel!
    
    @IBAction func previousTrackAction(_ sender: UIButton) {
    }
    
    @IBAction func nextTrackAction(_ sender: UIButton) {
    }
    
    @IBAction func pauseAndPlayAction(_ sender: UIButton) {
    }
    
    @IBAction func showPlaylistAction(_ sender: UIButton) {
    }
    
    func setContentForPlayerCell(track: TrackInfo?) {
        guard let track = track else { return }
        self.trackTitleLabel.text = track.trackModel?.title
        self.trackDescriptionLabel.text = track.trackModel?.description
        self.durationMaxLabel.text = String(describing: track.trackModel?.duration)
        if let image = track.trackModel?.image {
            let url = URL(string: image)
            self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
            self.trackBackgroundImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
        } 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
