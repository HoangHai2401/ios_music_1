//
//  TrackList.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

final class TrackInfo: BaseModel {
    var trackModel: TrackModel?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        trackModel <- map["track"]
    }
    
    init (track: TrackModel) {
        self.trackModel = track
    }
}

