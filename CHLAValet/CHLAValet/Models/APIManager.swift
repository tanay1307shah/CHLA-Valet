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
    
    func getAllCars(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/cars/getAllCars")!
        AF.request(url, method: .get).validate().responseJSON { response in
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

