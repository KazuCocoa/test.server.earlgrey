//
//  test_server_earlgreyUITests.swift
//  test.server.earlgreyUITests
//
//  Created by kazuaki matsuo on 2018/07/19.
//  Copyright © 2018 KazuCocoa. All rights reserved.
//

import XCTest

import Embassy
import Ambassador

class test_server_earlgreyUITests: UITestBase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        router[DefaultRouter.defaultURL] = DelayResponse(JSONResponse(handler: { _ in
            return [
                ["id": "01", "message": "hello world"]
            ]
        }))

        app.launch()
    }
    
}
