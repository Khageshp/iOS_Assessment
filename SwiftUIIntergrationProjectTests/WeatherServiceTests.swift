//
//  WeatherServiceTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Khagesh Patel on 28/6/24.
//

import CoreLocation

import XCTest
@testable import SwiftUIIntergrationProject

class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        weatherService = WeatherService(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        weatherService = nil
        mockNetworkService = nil
        super.tearDown()
    }

    // MARK: - Tests for retrieveCurrentWeather
    
    func testRetrieveCurrentWeatherSuccess() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedWeather = CurrentWeatherJSONData.createMock()
        mockNetworkService.fetchDataResult = .success(try! JSONEncoder().encode(expectedWeather))
        
        // When
        let expectation = self.expectation(description: "RetrieveCurrentWeather")
        var receivedWeather: CurrentWeatherJSONData?
        var receivedError: NetworkError?
        
        weatherService.retrieveCurrentWeather(location: location) { result in
            switch result {
            case .success(let weather):
                receivedWeather = weather
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNotNil(receivedWeather)
        XCTAssertEqual(receivedWeather, expectedWeather)
        XCTAssertNil(receivedError)
    }
    
    func testRetrieveCurrentWeatherFailure() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        mockNetworkService.fetchDataResult = .failure(.invalidResponse)
        
        // When
        let expectation = self.expectation(description: "RetrieveCurrentWeather")
        var receivedWeather: CurrentWeatherJSONData?
        var receivedError: NetworkError?
        
        weatherService.retrieveCurrentWeather(location: location) { result in
            switch result {
            case .success(let weather):
                receivedWeather = weather
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNil(receivedWeather)
        XCTAssertEqual(receivedError, .invalidResponse)
    }
    
    // MARK: - Tests for retrieveWeatherForecast
    
    func testRetrieveWeatherForecastSuccess() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedForecast = ForecastJSONData.createMock()
        mockNetworkService.fetchDataResult = .success(try! JSONEncoder().encode(expectedForecast))
        
        // When
        let expectation = self.expectation(description: "RetrieveWeatherForecast")
        var receivedForecast: ForecastJSONData?
        var receivedError: NetworkError?
        
        weatherService.retrieveWeatherForecast(location: location) { result in
            switch result {
            case .success(let forecast):
                receivedForecast = forecast
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNotNil(receivedForecast)
        XCTAssertEqual(receivedForecast, expectedForecast)
        XCTAssertNil(receivedError)
    }
    
    func testRetrieveWeatherForecastFailure() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        mockNetworkService.fetchDataResult = .failure(.noInternetConnection)
        
        // When
        let expectation = self.expectation(description: "RetrieveWeatherForecast")
        var receivedForecast: ForecastJSONData?
        var receivedError: NetworkError?
        
        weatherService.retrieveWeatherForecast(location: location) { result in
            switch result {
            case .success(let forecast):
                receivedForecast = forecast
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNil(receivedForecast)
        XCTAssertEqual(receivedError, .noInternetConnection)
    }
}

// MARK: - Mock Network Service


class MockNetworkService: NetworkServiceProtocol {
    var fetchDataResult: Result<Data, NetworkError> = .failure(.invalidData)
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        switch fetchDataResult {
        case .success(let data):
            completion(.success(data))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
