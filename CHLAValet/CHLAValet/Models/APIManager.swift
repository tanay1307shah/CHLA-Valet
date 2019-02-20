//
//  APIManager.swift
//  CHLAValet
//
//  Created by Ali Hashemi on 2/14/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    let baseURL = URL(string: Constants.someAPIURL)!
    
    func someAPICall() {
        
        AF.request(baseURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
            }
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
                debugPrint(JSON)
            }
        }
        
    }
}

