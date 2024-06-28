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
enum NetworkError: Error {
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
}

protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

/**
 A foundation class responsible for making API calls.

 - SeeAlso: `NetworkServiceProtocol` - Conforms to the `NetworkServiceProtocol` protocol.

 */

class NetworkService: NetworkServiceProtocol {
    
    /**
     Fetches data from the specified URL and calls the completion handler with either the fetched data or an error.

     - Parameters:
        - url: The URL from which to fetch the data.
        - completion: The completion handler called when the operation completes, with a `Result` enum indicating success (`Data`) or failure (`NetworkError`).

     */
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
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
                case .badURL:
                    return .invalidURL
                default:
                    return .message(error)
                }
            } else {
                return .message(error)
            }
        }
}
