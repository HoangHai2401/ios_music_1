//
//  TrackList.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class TrackList: BaseModel {
    var trackModel: trackModel?
    var score: Double?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        trackModel <- map["track"]
        score <- map["score"]
    }
}

