//
//  APIManager.swift
//  CHLAValet
//
//  Created by Ali Hashemi on 2/14/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
    let baseURL = URL(string: Constants.someAPIURL)!
    
    func someAPICall(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        AF.request(baseURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let obj = JSON(result)
                    onSuccess(obj)
                }
            case .failure(let error):
                onFailure(error)
            }
        }
        
    }
}

