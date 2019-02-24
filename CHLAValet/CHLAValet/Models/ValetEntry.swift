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
    var image: UIImage?
    var requested: Bool
    var paid: Bool
    var ready: Bool
    
    init(name: String, phoneNumber: String, ticketNumber: String, licensePlate: String, color: String, type: String, make: String, image: UIImage?, requested: Bool, paid: Bool, ready: Bool) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.ticketNumber = ticketNumber
        self.licensePlate = licensePlate
        self.color = color
        self.type = type
        self.make = make
        self.image = image
        self.requested = requested
        self.paid = paid
        self.ready = ready
    }
    
    init(obj: JSON) {
        self.name = "test"
        self.phoneNumber = obj["phoneNumber"].stringValue
        self.ticketNumber = obj["ticketNumber"].stringValue
        self.licensePlate = obj["licensePlate"].stringValue
        self.color = obj["color"].stringValue
        self.type = obj["type"].stringValue
        self.make = obj["make"].stringValue
        self.image = UIImage(named: "edit")!
        self.requested = false
        self.paid = false
        self.ready = false
    }
}
