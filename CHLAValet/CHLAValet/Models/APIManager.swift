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
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/cars/getAllCarsParked")!
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
        let parameters: Parameters = ["Name":valetEntry.name,
                                      "phone":valetEntry.phoneNumber,
                                      "license":valetEntry.licensePlate, "color":valetEntry.color,
                                      "type":valetEntry.type, "make":valetEntry.make,
                                      "location":valetEntry.location,
                                      "customerType":valetEntry.customerType]
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            for i in 0..<valetEntry.images.count{
                if let data = valetEntry.images[i]?.jpegData(compressionQuality: 0.25){
                    multipartFormData.append(data, withName: "images", fileName: "image\(i).jpeg", mimeType: "image/jpeg")
                }
            }
        }, to: Constants.CHLA_API_BASE_URL + "/cars/addCar", method: .post).responseString { response in
            switch response.result {
            case .success:
                debugPrint(response)
                onSuccess()
            case .failure(let error):
                debugPrint(response)
                onFailure(error)
            }
        }
    }
    
    func updateInfo(valetEntry: ValetEntry, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/cars/updateInfo/\(valetEntry.ticketNumber)")!
        let parameters: Parameters = ["name": valetEntry.name, "phone":valetEntry.phoneNumber,
                                      "license":valetEntry.licensePlate, "color":valetEntry.color, "type":valetEntry.type, "make":valetEntry.make, "images": "", "parkingLocation": valetEntry.location, "customerType": valetEntry.customerType]
        AF.request(url, method: .get, parameters: parameters).responseString { response in
            switch response.result {
            case .success:
                debugPrint(response)
                onSuccess()
            case .failure(let error):
                debugPrint(response)
                onFailure(error)
            }
        }
    }
    
    func requestCar(ticketNumber: String, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/request/" + ticketNumber)!
        AF.request(url, method: .get).responseString { response in
            switch response.result {
            case .success:
                debugPrint(response)
                onSuccess()
            case .failure(let error):
                debugPrint(response)
                onFailure(error)
            }
        }
    }
    
    func removeCar(ticketNumber: String, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url = URL(string: Constants.CHLA_API_BASE_URL + "/cars/paid/" + ticketNumber)!
        AF.request(url, method: .get).responseString { response in
            switch response.result {
            case .success:
                debugPrint(response)
                onSuccess()
            case .failure(let error):
                debugPrint(response)
                onFailure(error)
            }
        }
    }
}

