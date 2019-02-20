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
    
    var api:APIManager!
    
    override func setUp() {
        api = APIManager()
    }
    
    func testAPICall() {
        let expectedObj: JSON = [
            "title": "delectus aut autem",
            "completed": false,
            "userId": 1,
            "id": 1
        ]

        let expectation = self.expectation(description: "Getting response from API call")
        let onSuccessHandler: (JSON) -> (Void) = { obj in
            expectation.fulfill()
            XCTAssertEqual(obj, expectedObj)
        }
        let onFailureHandler: (Error) ->(Void) = { e in
            expectation.fulfill()
            XCTFail(e.localizedDescription)
        }
        
        api.someAPICall(onSuccess: onSuccessHandler, onFailure: onFailureHandler)
        waitForExpectations(timeout: 10, handler: nil)
    }

}
