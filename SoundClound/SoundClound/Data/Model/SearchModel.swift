//
//  SearchModel.swift
//  SoundClound
//
//  Created by Hai on 7/8/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import ObjectMapper

final class SearchModel: BaseModel {
    var tracks = [TrackModel]()
    
    init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        tracks <- map["collection"]
    }
}
