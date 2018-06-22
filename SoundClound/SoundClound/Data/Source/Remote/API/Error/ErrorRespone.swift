//
//  ErrorRespone.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var statusCode: String?
    var message: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        statusCode <- map["statusCode"]
        message <- map["message"]
    }
}
