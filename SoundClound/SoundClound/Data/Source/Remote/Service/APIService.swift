//
//  APIService.swift
//  SoundClound
//
//  Created by Hai on 6/22/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Alamofire

struct APIService {
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?,_ error: BaseError?) -> Void) {
        print("Request input")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("End Request Input")
        
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding).validate(statusCode: 200..<500).responseJSON { response in
            print(response.request?.url ?? "Error")
            print(response)
            switch response.result {
                case .success(let value):
                    guard let statusCode = response.response?.statusCode else {
                        completion(nil, BaseError.unexpectedError)
                        return
                    }
                    if statusCode == 200 {
                        let object = Mapper<T>().map(JSONObject: value)
                        completion(object, nil)
                    } else {
                        guard let error = Mapper<ErrorResponse>().map(JSONObject: value) else {
                            completion(nil, BaseError.httpError(httpCode: statusCode))
                            return
                        }
                            completion(nil, BaseError.apiFailure(error: error))
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
            }
        }
    }
}
