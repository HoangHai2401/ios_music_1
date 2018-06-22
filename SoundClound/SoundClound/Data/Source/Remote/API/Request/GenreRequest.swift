//
//  GenreRequest.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class GenreRequest: BaseRequest {
    required init(kind: String, genre: String, limit: Int, linkedPartitioning: Int) {
        let genreFormat = genre.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URLs.apiGenreUrl
        let body: [String: Any] = ["kind": kind, "genre": genreFormat, "client_id": APIKey.clientID, "limit": limit, "linked_partitioning": linkedPartitioning ]
        super.init(url: url, requestType: .get, body: body)
        }
    }
