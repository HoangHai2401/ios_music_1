//
//  BaseError.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)
    
    public var errorMessage: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            if let error = error {
                return error.message
            }
            return "Error"
        default:
            return "Unexpected Error"
        }
    }
    
    private func getHttpErrorMessage(httpCode: Int) -> String? {
        if (httpCode >= 300 && httpCode <= 308) {
            return "It was tranferred to a different URL."
        }
        if (httpCode >= 400 && httpCode <= 451) {
            return  "An error occurred on the application side. Please try again later."
        }
        if (httpCode >= 500 && httpCode <= 511) {
            return "A server error occurred. Please try again later."
        }
        return "An error occurred. Please try again later."
    }
}
