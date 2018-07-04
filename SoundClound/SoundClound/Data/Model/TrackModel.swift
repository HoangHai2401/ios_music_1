//
//  trackModel.swift
//  SoundClound
//
//  Created by Hai on 6/21/18.
//  Copyright © 2018 Hai. All rights reserved.
//
import UIKit
import ObjectMapper

final class TrackModel: BaseModel {
    var title = ""
    var id: Int = 0
    var description = ""
    var downloadable = false
    var downloadUrl = ""
    var streamable = false
    var image = ""
    var duration: Int = 0
    var url = ""
    
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
        downloadUrl <- map["download_url"]
    }
    
    init(title: String, description: String, image: String, duration: Int, id: Int, url: String) {
        self.title = title
        self.description = description
        self.duration = duration
        self.image = image
        self.url = url
        self.id = id
    }
}
