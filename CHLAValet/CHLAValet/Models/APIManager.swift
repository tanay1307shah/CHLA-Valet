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
    
    func getRequestedCars(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/request/getAllRequested")!
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
        var imageStrings = ["", "", "", ""]
        for i in 0..<min(imageStrings.count, valetEntry.images.count) {
            imageStrings[i] = imageTobase64(image: valetEntry.images[i]!)
            print(imageStrings[i])
        }
        let parameters: Parameters = ["Name": valetEntry.name, "phone":valetEntry.phoneNumber,
                                      "license":valetEntry.licensePlate, "color":valetEntry.color,
                                      "type":valetEntry.type, "make":valetEntry.make,
                                      "im1":imageStrings[0], "im2":imageStrings[1], "im3":imageStrings[2], "im4":imageStrings[3], "location":valetEntry.location,
                                      "customerType": valetEntry.customerType]
        AF.request(url, method: .post, parameters: parameters).responseString { response in
            if (response.result.description == "SUCCESS") {
                debugPrint(response)
                onSuccess()
            } else {
                // TODO: call onFailure()
                print("Failure in addCar request")
                debugPrint(response)
            }
        }
    }
    
    func updateInfo(valetEntry: ValetEntry, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/cars/updateInfo")!
        var imageStrings = ["", "", "", ""]
        for i in 0..<min(imageStrings.count, valetEntry.images.count) {
            imageStrings[i] = imageTobase64(image: valetEntry.images[i]!)
            print(imageStrings[i])
        }
        let parameters: Parameters = ["phone":valetEntry.phoneNumber, "ticket":valetEntry.ticketNumber,
                                      "license":valetEntry.licensePlate, "color":valetEntry.color, "type":valetEntry.type, "make":valetEntry.make, "im1": imageStrings[0], "im2":imageStrings[1], "im3":imageStrings[2], "im4":imageStrings[3]]
        AF.request(url, method: .get, parameters: parameters).responseString { response in
            if (response.result.description == "Completed") {
                onSuccess()
            } else {
                // TODO: call onFailure()
                print("Failure in updateInfo request")
                print(response.result.description)
            }
        }
    }
    
    func imageTobase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        let base64 = imageData.base64EncodedString(options: .lineLength64Characters)
        let base64url = base64.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    
    func base64ToImage(base64url: String) -> UIImage {
        var base64 = base64url.replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        // Add any necessary padding with `=`
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        let imageData: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
        let image: UIImage = UIImage(data: imageData)!
        return image
    }
}

