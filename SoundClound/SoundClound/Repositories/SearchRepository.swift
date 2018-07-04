//
//  SearchRepository.swift
//  SoundClound
//
//  Created by Hai on 7/8/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

protocol SearchRepository {
    func getResult(key: String, limit: Int,linkedpartitioning:  Int, completion: @escaping (BaseResult<SearchModel>) -> Void)
}

class SearchRepositoryImpl: SearchRepository {
    private var api: APIService
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getResult(key: String, limit: Int, linkedpartitioning: Int, completion: @escaping (BaseResult<SearchModel>) -> Void) {
        let input = SearchRequest(key: key, limit: limit, linkedpartitioning: linkedpartitioning)
        api.request(input: input) { (object: SearchModel?, error) in
            guard let object = object else {
                guard let error = error else {
                    completion(.failure(error: nil))
                    return
                }
                completion(.failure(error: error))
                return
            }
            completion(.success(object))
        }
    }
}
