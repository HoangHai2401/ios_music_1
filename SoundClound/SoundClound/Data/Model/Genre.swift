//
//  Genres.swift
//  SoundClound
//
//  Created by Hai on 6/25/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

enum GenreKind: String {
    case trending
    case top
}

enum GenreType: String {
    case allMusic = "All Music"
    case allAudio = "All Audio"
    case alternativeRock = "Alternative Rock"
    case ambient = " Ambient"
    case classical = "Classical"
    case country = "Country"
    
    var query: String {
        switch self {
        case .allMusic:
            return "soundcloud:genres:all-music"
        case .allAudio:
            return "soundcloud:genres:all-audio"
        case .alternativeRock:
            return "soundcloud:genres:alternativerock"
        case .ambient:
            return "soundcloud:genres:ambient"
        case .classical:
            return "soundcloud:genres:classical"
        case .country:
            return "soundcloud:genres:country"
        }
    }
}
