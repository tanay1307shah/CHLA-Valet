//
//  ValetEntry.swift
//  CHLAValet
//
//  Created by Ali Hashemi on 2/14/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ValetEntry {
    var name: String
    var phoneNumber: String
    var ticketNumber: String
    var licensePlate: String
    var color: String
    var type: String
    var make: String
    var images: [UIImage?]
    var imageURLs: [URL?]
    var location: String
    var customerType: String
    
    init(name: String, phoneNumber: String, ticketNumber: String, licensePlate: String, color: String, type: String, make: String, images: [UIImage?], customerType: String, location: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.ticketNumber = ticketNumber
        self.licensePlate = licensePlate
        self.color = color
        self.type = type
        self.make = make
        self.images = images
        self.imageURLs = []
        self.customerType = customerType
        self.location = location
    }
    
    init(obj: JSON) {
        self.name = obj["name"].stringValue
        self.phoneNumber = obj["phoneNumber"].stringValue
        self.ticketNumber = obj["ticketNumber"].stringValue
        self.licensePlate = obj["licensePlate"].stringValue
        self.color = obj["color"].stringValue
        self.type = obj["type"].stringValue
        self.make = obj["make"].stringValue
        
        let imagesArray = obj["imageList"].arrayValue
        self.images = []
        self.imageURLs = []
        for image in imagesArray{
            self.images.append(nil)
            self.imageURLs.append(URL(string: image.stringValue))
        }
        self.location = obj["location"].stringValue
        self.customerType = obj["customerType"].stringValue
    }
}
