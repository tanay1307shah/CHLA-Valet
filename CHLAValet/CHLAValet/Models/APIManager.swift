//
//  APIManager.swift
//  CHLAValet
//
//  Created by Ali Hashemi on 2/14/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import Foundation

class APIManager {
    
    let baseURL = Constants.someAPIURL
    
    func someAPICall(completion: @escaping (Error?) -> Void) {
        // Something that takes some time to complete.
        completion(nil)
        // Or completion(SomeError.veryBadError)
    }
}
