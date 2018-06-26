//
//  trackCollectionByGenreModel.swift
//  SoundClound
//
//  Created by Hai on 6/21/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import ObjectMapper

final class GenreModel: BaseModel {
    var kind = GenreKind.top
    var type = GenreType.allMusic
    var tracks = [TrackInfo]()
    
    init(type: GenreType, kind: GenreKind) {
        self.type = type
        self.kind = kind
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        tracks <- map["collection"]
    }
}
