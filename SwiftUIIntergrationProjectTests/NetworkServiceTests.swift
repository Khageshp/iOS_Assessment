//
//  NetworkServiceTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Khagesh Patel on 28/6/24.
//

import XCTest
@testable import SwiftUIIntergrationProject

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkService = NetworkService(session: mockURLSession)
    }
    
    override func tearDown() {
        networkService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        // Given
        let url = URL(string: "https://example.com")!
        let expectedData = "Success".data(using: .utf8)!
        mockURLSession.data = expectedData
        mockURLSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        let expectation = self.expectation(description: "FetchData")
        var receivedData: Data?
        var receivedError: NetworkError?
        
        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNotNil(receivedData)
        XCTAssertEqual(receivedData, expectedData)
        XCTAssertNil(receivedError)
    }
    
    func testFetchDataInvalidURL() {
        // Given
        let url = URL(string: "invalid_url")!
        let error = URLError(.badURL)
        mockURLSession.error = error

        // When
        let expectation = self.expectation(description: "FetchData")
        var receivedData: Data?
        var receivedError: NetworkError?

        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNil(receivedData)
        XCTAssertEqual(receivedError, .invalidURL)
    }
    
    func testFetchDataNoInternetConnection() {
        // Given
        let url = URL(string: "https://example.com")!
        let error = URLError(.notConnectedToInternet)
        mockURLSession.error = error
        
        // When
        let expectation = self.expectation(description: "FetchData")
        var receivedData: Data?
        var receivedError: NetworkError?
        
        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNil(receivedData)
        XCTAssertEqual(receivedError, .noInternetConnection)
    }
    
    func testFetchDataInvalidResponse() {
        // Given
        let url = URL(string: "https://example.com")!
        mockURLSession.data = Data()
        mockURLSession.response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        // When
        let expectation = self.expectation(description: "FetchData")
        var receivedData: Data?
        var receivedError: NetworkError?
        
        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNil(receivedData)
        XCTAssertEqual(receivedError, .invalidResponse)
    }
    
    func testFetchDataInvalidData() {
        // Given
        let url = URL(string: "https://example.com")!
        mockURLSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        let expectation = self.expectation(description: "FetchData")
        var receivedData: Data?
        var receivedError: NetworkError?
        
        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNil(receivedData)
        XCTAssertEqual(receivedError, .invalidData)
    }
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    func resume() {
        closure()
    }
}
