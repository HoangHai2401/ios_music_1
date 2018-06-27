//
//  BaseResult.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T)
    case failure(error: BaseError?)
}
