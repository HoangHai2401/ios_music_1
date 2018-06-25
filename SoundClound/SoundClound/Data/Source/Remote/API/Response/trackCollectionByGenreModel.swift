//
//  trackCollectionByGenreModel.swift
//  SoundClound
//
//  Created by Hai on 6/21/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import ObjectMapper

class trackCollectionByGenreModel: BaseModel {
    var genre: String?
    var kind: String?
    var trackList: [TrackList]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        genre <- map["genre"]
        kind <- map["kind"]
        trackList <- map["collection"]
    }
}
