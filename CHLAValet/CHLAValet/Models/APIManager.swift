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
    
    func addCar(valetEntry: ValetEntry, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/cars/addCar")!
        let parameters: Parameters = ["phone":valetEntry.phoneNumber, "ticket":valetEntry.ticketNumber,
                                      "license":valetEntry.licensePlate, "color":valetEntry.color, "type":valetEntry.type, "make":valetEntry.make]
        print(parameters)
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print("response")
            print(response.result)
            onSuccess()
//            switch response.result {
//                case .success:
//                    onSuccess()
//                    print("success")
//                case .failure(let error):
//                    onFailure(error)
//            }
        }
    }
    
    private func imageTobase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString()
    }
    
    private func base64ToImage(base64: String) -> UIImage {
        let imageData: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
        let image: UIImage = UIImage(data: imageData)!
        return image
    }
}

