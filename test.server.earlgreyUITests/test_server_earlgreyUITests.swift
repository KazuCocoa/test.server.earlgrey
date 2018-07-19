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

class test_server_earlgreyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

        let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
        let router = Router()
        let server = DefaultHTTPServer(
            eventLoop: loop,
            port: 8080, app: router.app
        )

        router["/api/v2/users"] = JSONResponse() {
            _ -> Any in
            return [
                ["id": "01", "name": "john"],
                ["id": "02", "name": "tom"]
            ]
        }
        // Start HTTP server to listen on the port
        try! server.start()
        // Run event loop (this should be ran in another thread)
        loop.runForever()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
