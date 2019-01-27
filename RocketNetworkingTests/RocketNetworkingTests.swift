//
//  RocketNetworkingTests.swift
//  RocketNetworkingTests
//
//  Created by Will Brandin on 1/26/19.
//  Copyright © 2019 williambrandin. All rights reserved.
//

import XCTest
@testable import RocketNetworking

class RocketNetworkingTests: XCTestCase {

    var networkManager: RocketNetworkManager<RKTestEndpoint>?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        networkManager = RocketNetworkManager<RKTestEndpoint>()
        networkManager?.setupNetworkLayer(in: .staging)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchDetails() {
        var school: School?
        
        let expectation = self.expectation(description: "fetching")

        let endpoint = RKTestEndpoint.getSchool(id: "5ad7da89a220b9e4aa3f2099")
        
        networkManager?.request(for: endpoint, School.self) { result in
            switch result {
            case .success(let schoolResult):
                school = schoolResult
            case .error(let error):
                print(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fullfilled, or time out
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(school?.schoolName, "Smith High School")
    }
    
    func testPostDetail() {
        var school: School?
        
        let expectation = self.expectation(description: "posting")
        
        let form = ContactForm(name: "Will", email: "william.brandin@gmail.com", phoneNumber: "123411234", message: "Hello World")
        let endpoint = RKTestEndpoint.submitForm(data: form)
        
        networkManager?.request(for: endpoint, School.self) { result in
            switch result {
            case .success(let schoolResult):
                school = schoolResult
            case .error(let error):
                print(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fullfilled, or time out
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(school?.schoolName, "Smith High School")
    }

}
