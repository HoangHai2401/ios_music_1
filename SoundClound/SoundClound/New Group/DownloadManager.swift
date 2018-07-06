//
//  DownloadManager.swift
//  SoundClound
//
//  Created by Hai on 7/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

final class DownloadManager {
    
    static var trackDirectoryURL: URL?
    class func downloadTrack(track: TrackInfo, progressView: UIProgressView) {
        progressView.alpha = 1
        let apikey = APIKey()
        var counter: Double = 0
        let clientID = "?client_id=" + apikey.clientID
        guard let trackDownloadUrl = track.trackModel?.downloadUrl,
        let url = URL(string: trackDownloadUrl + clientID) else { return }
        Alamofire.request(url).downloadProgress(closure : { progress in
            counter = progress.fractionCompleted
            print(counter)
            let fractionalProgress = Float(counter)
            progressView.setProgress(fractionalProgress, animated: true)
        }).responseData{ response in
            guard let trackmodel = track.trackModel else { return }
            let trackTitle = "\(trackmodel.id).mp3"
            if let data = response.result.value {
                guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                let trackURL = documentsURL.appendingPathComponent("\(trackTitle)")
                do {
                    try data.write(to: trackURL)
                    print(trackURL)
                    self.trackDirectoryURL = trackURL
                    _ = DatabaseManager.insertTrack(track: track)
                } catch {
                    print("Something went wrong!")
                }
                
            }
        }
    }
}
