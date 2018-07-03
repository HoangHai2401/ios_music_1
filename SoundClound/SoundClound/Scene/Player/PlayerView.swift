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
    @IBOutlet private weak var shuffleControlImage: UIButton!
    @IBOutlet private weak var loopControlImage: UIButton!
    
    fileprivate enum LoopStatus: Int {
        case nonLoop 
        case allLoop
        case oneLoop
    }

    fileprivate var player: AVPlayer?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var isShuffling = false
    fileprivate var loopStatus: LoopStatus = .nonLoop
    fileprivate let apiKey = APIKey()
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
    var nextShuffleTrack: (() -> Void)?
    var playBack: (() -> Void)?
    var loopAll: (() -> Void)?
    
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
        if self.isShuffling == true {
            nextShuffleTrack?()
        } else {
            nextTrack?()
            if self.loopStatus == .allLoop {
                loopAll?()
            }
        }
    }
    
    @IBAction func shuffleControlAction(_ sender: Any) {
        if self.isShuffling == true {
            self.shuffleControlImage.setImage(#imageLiteral(resourceName: "ShuffleButton"), for: .normal)
            self.isShuffling = false
        } else {
            self.shuffleControlImage.setImage(#imageLiteral(resourceName: "ShuffleButtonSelected"), for: .normal)
            self.isShuffling = true
        }
    }

    @IBAction func loopControlAction(_ sender: Any) {
        switch loopStatus {
        case .nonLoop:
            self.loopControlImage.setImage(#imageLiteral(resourceName: "LoopButtonLoopAll"), for: .normal)
            self.loopStatus = .allLoop
        case .allLoop:
            self.loopControlImage.setImage(#imageLiteral(resourceName: "LoopButtonLoopOne"), for: .normal)
            self.loopStatus = .oneLoop
        default:
            self.loopControlImage.setImage(#imageLiteral(resourceName: "LoopButtonNonLoop"), for: .normal)
            self.loopStatus = .nonLoop
        }
    }

    private func playTrack(track: TrackInfo?) {
        guard let id = track?.trackModel?.id ,let url = URL (string: "https://api.soundcloud.com/tracks/\(id)/stream?client_id=\(apiKey.clientID)") else { return }
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
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Finished")
        if self.loopStatus == .oneLoop {
            playBack?()
        } else {
            if self.isShuffling == true {
                nextShuffleTrack?()
            } else {
                nextTrack?()
                if self.loopStatus == .allLoop {
                    loopAll?()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNibContent()
    }
}
