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
import MediaPlayer

class PlayerView: UIView, NibOwnerLoadable {
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackBackgroundImage: UIImageView!
    @IBOutlet private weak var trackTitle: UILabel!
    @IBOutlet private weak var trackDescription: UILabel!
    @IBOutlet private weak var trackMinDuration: UILabel!
    @IBOutlet private weak var trackMaxDuration: UILabel!
    @IBOutlet private weak var pauseAndPlayButtonImage: UIButton!
    @IBOutlet private weak var shuffleControlImage: UIButton!
    @IBOutlet private weak var loopControlImage: UIButton!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var downloadActionVisible: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var downloadCompleteLabel: UILabel!
    
    private struct Constants {
        static let timeInterval = 0.1
        static let playerLayerHeight = 10
        static let playerLayerWidth = 10
        static let oneThousand = 1000
        static let secondsInAMinute = 60
    }
    
    fileprivate enum LoopStatus {
        case non
        case all
        case one
    }

    fileprivate var player: AVPlayer?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var isShuffling: Bool?
    fileprivate var loopStatus: LoopStatus = .non
    fileprivate let apiKey = APIKey()
    var timer: Timer?
    var track: TrackInfo? {
        didSet {
            timer?.invalidate()
            setPlayerUI()
            notificationSetup()
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
            if self.loopStatus == .all {
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
        case .non:
            self.loopControlImage.setImage(#imageLiteral(resourceName: "LoopButtonLoopAll"), for: .normal)
            self.loopStatus = .all
        case .all:
            self.loopControlImage.setImage(#imageLiteral(resourceName: "LoopButtonLoopOne"), for: .normal)
            self.loopStatus = .one
        default:
            self.loopControlImage.setImage(#imageLiteral(resourceName: "LoopButtonNonLoop"), for: .normal)
            self.loopStatus = .non
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        //DatabaseManager.cleanAllCoreData()
        guard let track = track else { return }
        guard let trackModel = track.trackModel else { return }
        if DatabaseManager.checkData(track: trackModel) == nil {
            DownloadManager.downloadTrack(track: track, progressView: progressView)
            track.trackModel?.url = String(describing: DownloadManager.trackDirectoryURL)
            downloadActionVisible.alpha = 0
            downloadCompleteLabel.text = "Track Downloaded!"
            downloadCompleteLabel.alpha = 1
        } else {
            downloadActionVisible.setTitle("Track downloaded", for: .normal)
            downloadActionVisible.tintColor = UIColor.orange
            downloadActionVisible.setImage(#imageLiteral(resourceName: "DownloadIconSelected"), for: .normal)
            print("Track Already downloaded")
        }
    }
    
    @objc private func updateTime() {
        guard let cmTime = player?.currentTime() else { return }
        trackSlider.value = Float(CMTimeGetSeconds(cmTime)) * Float(Constants.oneThousand)
        let currentTime: Int = Int(CMTimeGetSeconds(cmTime)) * Constants.oneThousand
        self.trackMinDuration.text = convertTime(time: currentTime)
    }
    
    private func convertTime(time: Int) -> String {
        let minute = time/(Constants.oneThousand * Constants.secondsInAMinute)
        let second = time/Constants.oneThousand - minute * Constants.secondsInAMinute
        if second < 10 {
            return "\(minute):0\(second)"
        } else {
            return "\(minute):\(second)"
        }
    }
    
    private func setPlayerUI() {
        guard let track = track else {
            self.reloadInputViews()
            return
        }
        self.trackTitle.text = track.trackModel?.title
        self.trackDescription.text = track.trackModel?.description
        if let image = track.trackModel?.image {
            let url = URL(string: image)
            self.trackImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
            self.trackBackgroundImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "SongImage2"))
        }
        if let maxDuration = track.trackModel?.duration {
            self.trackSlider.maximumValue = Float(maxDuration)
            self.trackMaxDuration.text = convertTime(time: maxDuration)
        }
        if let downloadable = track.trackModel?.downloadable {
            self.downloadActionVisible.setTitle("Donwload", for: .normal)
            self.downloadActionVisible.isHidden = !downloadable
        }
        self.trackSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumbImage"), for: .normal)
        self.progressView.setProgress(0, animated: true)
        self.downloadCompleteLabel.alpha = 0
        self.progressView.alpha = 0
    }
    
    private func notificationSetup() {
        MPRemoteCommandCenter.shared().pauseCommand.addTarget(self, action: #selector(self.pausePlayerCommand))
        MPRemoteCommandCenter.shared().playCommand.addTarget(self, action: #selector(self.playPlayerCommand))
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget(self, action: #selector(self.nextTrackCommand))
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget(self, action: #selector(self.previousTrackAction(_:)))
    }
    
    private func playTrack(track: TrackInfo?) {
        guard let track = track?.trackModel else { return }
        let id = track.id
        let isOfline = OfflineChecker.isOffline
        if isOfline == false {
            guard let url = URL (string: "https://api.soundcloud.com/tracks/\(id)/stream?client_id=\(apiKey.clientID)") else { return }
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        } else {
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let trackURL = documentsURL.appendingPathComponent("\(id).mp3")
            playerItem = AVPlayerItem(url: trackURL)
            player = AVPlayer(playerItem: playerItem)
        }
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: Constants.playerLayerWidth, height: Constants.playerLayerHeight)
        removeSublayer()
        self.layer.addSublayer(playerLayer)
        player?.play()
        
        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.pauseAndPlayButtonImage.setImage(#imageLiteral(resourceName: "PauseButton"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    private func removeSublayer() {
        guard let layerCount = self.layer.sublayers?.count else { return }
        if layerCount > 0 {
            self.layer.sublayers?.forEach { if $0.frame == CGRect(x: 0, y: 0, width: Constants.playerLayerWidth, height: Constants.playerLayerHeight) {
                $0.removeFromSuperlayer()
                }
            }
        }
    }
    
    @objc func pausePlayerCommand() {
        if self.player?.rate != 0 {
            self.player?.pause()
            self.pauseAndPlayButtonImage.setImage(#imageLiteral(resourceName: "PlayButton"), for: .normal)
        }
    }
    
    @objc func playPlayerCommand() {
        if self.player?.rate == 0 {
            self.player?.play()
            self.pauseAndPlayButtonImage.setImage(#imageLiteral(resourceName: "PauseButton"), for: .normal)
        }
    }
    
    @objc func nextTrackCommand() {
        if self.isShuffling == true {
            nextShuffleTrack?()
        } else {
            nextTrack?()
            if self.loopStatus == .all {
                loopAll?()
            }
        }
    }
    
    @objc func previouTrackCommand() {
        previousTrack?()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Finished")
        self.timer?.invalidate()
        if self.loopStatus == .one {
            playBack?()
        } else {
            if self.isShuffling == true {
                nextShuffleTrack?()
            } else {
                nextTrack?()
                if self.loopStatus == .all {
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
