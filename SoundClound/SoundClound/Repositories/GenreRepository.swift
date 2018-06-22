//
//  GenreRepository.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

protocol GenreRepository {
    func getGenre(kind: String, genre: String, limit: Int, linkedPartitioning: Int, completion: @escaping (BaseResult<trackCollectionByGenreModel>) -> Void)
}

class GenreRepositoryImpl: GenreRepository {
    private var api: APIService
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getGenre(kind: String, genre: String, limit: Int, linkedPartitioning: Int, completion: @escaping (BaseResult<trackCollectionByGenreModel>) -> Void) {
        let input = GenreRequest(kind: kind,genre: genre, limit: limit, linkedPartitioning: linkedPartitioning)
        api.request(input: input) { (object: trackCollectionByGenreModel?, error) in
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
