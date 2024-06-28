//
//  NetworkService.swift
//  SwiftUIIntergrationProject
//
//  Created by Khagesh Patel on 26/6/24.
//

import Foundation

/**
 Enumeration representing various network-related errors.
 
 - SeeAlso: `Error` - Conforms to the Swift `Error` protocol.
 */
enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidData
    case invalidResponse
    case noInternetConnection
    case message(_ error: Error?)
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return NetworkErrorMessage.invalidURLMessage
        case .invalidData:
            return NetworkErrorMessage.invalidDataMessage
        case .invalidResponse:
            return NetworkErrorMessage.invalidResponseMessage
        case .noInternetConnection:
            return NetworkErrorMessage.noInternetMessage
        case .message(_):
            return NetworkErrorMessage.unknownErrorMessage
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidData, .invalidData):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.message(let lhsError), .message(let rhsError)):
            // Compare the errors if they are not nil
            if let lhsError = lhsError, let rhsError = rhsError {
                return (lhsError as NSError).domain == (rhsError as NSError).domain &&
                (lhsError as NSError).code == (rhsError as NSError).code
            }
            // If both errors are nil, they are considered equal
            return lhsError == nil && rhsError == nil
        default:
            return false
        }
    }
    
}

protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

/**
 A foundation class responsible for making API calls.
 
 - SeeAlso: `NetworkServiceProtocol` - Conforms to the `NetworkServiceProtocol` protocol.
 
 */

class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    /**
     Fetches data from the specified URL and calls the completion handler with either the fetched data or an error.
     
     - Parameters:
     - url: The URL from which to fetch the data.
     - completion: The completion handler called when the operation completes, with a `Result` enum indicating success (`Data`) or failure (`NetworkError`).
     
     */
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        self.session.dataTask(with: url) { data, response, error in
            // Check if there's an error returned from the data task.
            if let error = error {
                // If there's an error, call the completion handler with a failure case,
                // wrapping the error inside the .message case of NetworkError.
                let networkError = self.mapError(error)
                completion(.failure(networkError))
                return
            }
            
            // Ensure that data is received from the server.
            guard let data = data else {
                // If data is nil, call the completion handler with a failure case,
                // indicating that the received data is invalid.
                completion(.failure(.invalidData))
                return
            }
            
            // Ensure that the response is an HTTPURLResponse and the status code indicates success (200-299).
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                // If the response is not as expected (not a success status code), call the completion handler
                // with a failure case, indicating an invalid HTTP response.
                completion(.failure(.invalidResponse))
                return
            }
            
            // If all checks pass, call the completion handler with a success case,
            // passing the received data to the success case of the Result enum.
            completion(.success(data))
        }.resume() // Start the data task.
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternetConnection
            case .badURL, .unsupportedURL:
                return .invalidURL
            default:
                return .message(error)
            }
        } else {
            return .message(error)
        }
    }
}

// Protocol that abstracts URLSessionDataTask to enable mocking for testing purposes
protocol URLSessionDataTaskProtocol {
    func resume()
}

// Make URLSessionDataTask conform to URLSessionDataTaskProtocol to use it in the production code
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// Protocol that abstracts URLSession to enable mocking for testing purposes
protocol URLSessionProtocol {
    // Method to create a data task that conforms to URLSessionDataTaskProtocol
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

// Make URLSession conform to URLSessionProtocol to use it in the production code
extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        // Return the data task as URLSessionDataTask which conforms to URLSessionDataTaskProtocol
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
