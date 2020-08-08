//
//  SearchingImageTests.swift
//  SearchingImageTests
//
//  Created by Paul Jang on 2020/08/08.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import XCTest
@testable import SearchingImage

class SearchingImageTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  
    func testHTTPSearch() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        let viewModel = SearchViewModel()
        var response: ImageSearchResponse?
        var Error: Error?
        viewModel.searchKeyword("치킨", 1) { result in
            switch result {
                case .success(let data):
                    response = data
                    break
                case .failure(let error):
                    print(error)
                    Error = error
                    break
            }
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNil(Error)
        XCTAssertNotNil(response)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
