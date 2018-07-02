//
//  PlayerView.swift
//  SoundClound
//
//  Created by Hai on 7/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import AVFoundation

class PlayerView: UIView, NibOwnerLoadable {
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackBackgroundImage: UIImageView!
    @IBOutlet private weak var trackTitle: UILabel!
    @IBOutlet private weak var trackDescription: UILabel!
    @IBOutlet private weak var trackProgress: NSLayoutConstraint!
    @IBOutlet private weak var trackMinDuration: UILabel!
    @IBOutlet private weak var trackMaxDuration: UILabel!
    @IBOutlet private weak var pauseAndPlayButtonImage: UIButton!
    
    fileprivate var player: AVPlayer?
    fileprivate var playerItem: AVPlayerItem?
    var track: TrackInfo? {
        didSet {
            guard let track = track else {
                self.reloadInputViews()
                return }
            self.trackTitle.text = track.trackModel?.title
            self.trackDescription.text = track.trackModel?.description
            if let image = track.trackModel?.image {
                let url = URL(string: image)
                self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
                self.trackBackgroundImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
            }
            playTrack(track: track)
        }
    }
    
    var nextTrack: (() -> Void)?
    var previousTrack: (() -> Void)?
    
    @IBAction private func previousTrackAction(_ sender: Any) {
        previousTrack?()
    }
    
    @IBAction private func pauseAndPlayAction(_ sender: Any) {
        if player?.rate == 0 {
            player?.play()
            self.pauseAndPlayButtonImage.setImage(#imageLiteral(resourceName: "PauseButton"), for: .normal)
        } else {
            player?.pause()
            self.pauseAndPlayButtonImage.setImage(#imageLiteral(resourceName: "PlayButton"), for: .normal)
        }
    }
    
    @IBAction private func nextTrackAction(_ sender: Any) {
        nextTrack?()
    }
    
    private func playTrack(track: TrackInfo?) {
        guard let id = track?.trackModel?.id else { return }
        guard let url = URL (string: "https://api.soundcloud.com/tracks/\(id)/stream?client_id=a7Ucuq0KY8Ksn8WzBG6wj4x6pcId6BpU") else { return }
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        guard let layerCount = self.layer.sublayers?.count else { return }
        if layerCount > 0 {
            self.layer.sublayers?.forEach{ if $0.frame == CGRect(x: 0, y: 0, width: 10, height: 50) {
                $0.removeFromSuperlayer()
                }
            }
        }
        self.layer.addSublayer(playerLayer)
        player?.play()
        self.pauseAndPlayButtonImage.setImage(#imageLiteral(resourceName: "PauseButton"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNibContent()
    }
    
}
