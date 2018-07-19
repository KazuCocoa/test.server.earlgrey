//
//  uitestbase.swift
//  test.server.earlgreyUITests
//
//  Created by kazuaki matsuo on 2018/07/20.
//  Copyright © 2018 KazuCocoa. All rights reserved.
//

import Foundation
import XCTest

import Embassy
import Ambassador

class DefaultRouter: Router {
    static let defaultURL = "/api/default"

    override init() {
        super.init()
        self[DefaultRouter.defaultURL] = DelayResponse(JSONResponse(handler: ({ environ -> Any in
            return [
                ["id": "01", "message": "hello world"]
            ]
        })))
    }
}

class UITestBase: XCTestCase {
    let port = 8080
    var router: Router!
    var eventLoop: EventLoop!
    var server: HTTPServer!
    var app: XCUIApplication!

    var eventLoopThreadCondition: NSCondition!
    var eventLoopThread: Thread!

    override func setUp() {
        super.setUp()
        setUpWebApp()
        setUpApp()
    }

    private func setUpWebApp() {
        eventLoop = try! SelectorEventLoop(selector: try! KqueueSelector())
        router = DefaultRouter()
        server = DefaultHTTPServer(eventLoop: eventLoop, port: port, app: router.app)

        try! server.start()

        eventLoopThreadCondition = NSCondition()
        eventLoopThread = Thread(target: self, selector: #selector(runEventLoop), object: nil)
        eventLoopThread.start()
    }

    private func setUpApp() {
        app = XCUIApplication()
        app.launchEnvironment["ENVOY_BASEURL"] = "http://localhost:\(port)"
    }

    override func tearDown() {
        super.tearDown()
        app.terminate()
        server.stopAndWait()
        eventLoopThreadCondition.lock()
        eventLoop.stop()
        while eventLoop.running {
            if !eventLoopThreadCondition.wait(until: Date().addingTimeInterval(10)) {
                fatalError("Join eventLoopThread timeout")
            }
        }
    }

    @objc func runEventLoop() {
        eventLoop.runForever()
        eventLoopThreadCondition.lock()
        eventLoopThreadCondition.signal()
        eventLoopThreadCondition.unlock()
    }
}

