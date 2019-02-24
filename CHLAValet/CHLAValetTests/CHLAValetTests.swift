//
//  CHLAValetTests.swift
//  CHLAValetTests
//
//  Created by Ali Hashemi on 2/20/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import XCTest
@testable import CHLAValet
import SwiftyJSON

class CHLAValetTests: XCTestCase {
    
    override func setUp() {
    }
    
    func testGetAllCars() {
        let expectation = self.expectation(description: "Getting all cars from API call")
        let onSuccessHandler: (JSON) -> (Void) = { obj in
            print(obj)
            expectation.fulfill()
        }
        let onFailureHandler: (Error) ->(Void) = { e in
            expectation.fulfill()
        }
        
        APIManager.shared.getAllCars(onSuccess: onSuccessHandler, onFailure: onFailureHandler)
        waitForExpectations(timeout: 10, handler: nil)
    }

}
