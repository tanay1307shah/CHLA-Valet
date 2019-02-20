//
//  CHLAValetTests.swift
//  CHLAValetTests
//
//  Created by Ali Hashemi on 2/20/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import XCTest
@testable import CHLAValet 

class CHLAValetTests: XCTestCase {
    
    var api:APIManager!
    
    override func setUp() {
        api = APIManager()
    }
    
    func testAPICall() {
        api.someAPICall()
    }

}
