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

    // Case to represent an invalid URL error.
    case invalidURL
    
    // Case to represent an error where the received data is invalid or nil.
    case invalidData
    
    // Case to represent an invalid HTTP response error, e.g., status code is not 200-299.
    case invalidResponse
    
    // Case to represent any other error, optionally wrapping another Error.
    case message(_ error: Error?)
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
                completion(.failure(.message(error)))
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
}
