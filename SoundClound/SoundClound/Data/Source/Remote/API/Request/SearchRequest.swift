//
//  SearchRequest.swift
//  SoundClound
//
//  Created by Hai on 7/8/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class SearchRequest: BaseRequest {
    let ApiKey = APIKey()
    required init(key: String, limit: Int, linkedpartitioning: Int) {
        let keyFormat = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URLs.apiSearchUrl
        let body: [String:Any] = ["client_id": ApiKey.clientID, "q": keyFormat, "limit": limit, "linked_partitioning": linkedpartitioning]
        super.init(url: url, requestType: .get, body: body)
    }
}
