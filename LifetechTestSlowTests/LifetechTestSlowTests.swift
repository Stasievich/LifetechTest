//
//  LifetechTestSlowTests.swift
//  LifetechTestSlowTests
//
//  Created by Victor on 3/21/21.
//

import XCTest
@testable import LifetechTest

class LifetechTestSlowTests: XCTestCase {

    var sessionUnderTest: URLSession!
    
    override func setUp(){
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }

    override func tearDown(){
        sessionUnderTest = nil
        super.tearDown()
    }

    func testValidCallToProductDetails() {
      let url = URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/5/detail")
      let promise = expectation(description: "Status code: 200")
      
      let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      waitForExpectations(timeout: 5, handler: nil)
    }

    func testCallToProductsListCompletes() {
      let url = URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list")
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?
      
      let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      waitForExpectations(timeout: 5, handler: nil)
      
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }

}
