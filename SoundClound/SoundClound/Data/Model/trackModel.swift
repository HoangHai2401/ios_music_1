//
//  trackModel.swift
//  SoundClound
//
//  Created by Hai on 6/21/18.
//  Copyright © 2018 Hai. All rights reserved.
//
import UIKit
import ObjectMapper

class trackModel: BaseModel {
    var title: String?
    var id: Int?
    var description: String?
    var downloadable: String?
    var streamable: String?
    var image: String?
    var duration: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        id <- map["id"]
        description <- map["description"]
        downloadable <- map["downloadable"]
        streamable <- map["streamable"]
        image <- map["artwork_url"]
        duration <- map["duration"]
    }
}
