import Foundation
import Combine
import MapKit

  //
  ///
  /**
   TODO: Fill in this to retrieve current weather, and 5 day forecast 
   * Use func currentWeatherURL(location: CLLocation) -> URL? to get the CurrentWeatherJSONData
   * Use func forecastURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL? to get the ForecastJSONData
  
   Once you have both the JSON Data, you can map:
    * CurrentWeatherJSONData -> CurrentWeatherDisplayData
    * ForecastJSONData ->ForecastDisplayData
   Both of these DisplayData structs contains the text you can bind/map to labels and we have included convience init that takes the JSON data so you can easily map them
   */

/**
 Protocol defining methods to retrieve weather data for a location.
 - SeeAlso: `NetworkError` - Conforms to the `NetworkError` enum for error handling.
 */
protocol WeatherServiceProtocol {
    /**
     Retrieves the current weather data for a given location.
     - Parameters:
        - location: The CLLocation object representing the location.
        - completion: Completion handler with a `Result` enum indicating success (`CurrentWeatherJSONData`) or failure (`NetworkError`).
     */
    func retrieveCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeatherJSONData, NetworkError>) -> Void)
    
    /**
     Retrieves the weather forecast data for a given location.
     - Parameters:
        - location: The CLLocation object representing the location.
        - completion: Completion handler with a `Result` enum indicating success (`ForecastJSONData`) or failure (`NetworkError`).
     */
    func retrieveWeatherForecast(location: CLLocation, completion: @escaping (Result<ForecastJSONData, NetworkError>) -> Void)
}


/**
 Service for retrieving weather and forecost data using a network service.
 - SeeAlso: `WeatherServiceProtocol` - Conforms to the `WeatherServiceProtocol` protocol.
 */
struct WeatherService {
    
    private let networkService: NetworkServiceProtocol
    
    /**
     Initializes the WeatherService with a network manager.
     - Parameters:
        - networkService: An object conforming to `NetworkServiceProtocol` to handle network requests.
     */
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    /**
     Retrieves the current weather data for a given location.
     - Parameters:
        - location: The CLLocation object representing the location.
        - completion: Completion handler with a `Result` enum indicating success (`CurrentWeatherJSONData`) or failure (`NetworkError`).
     */
    func retrieveCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeatherJSONData, NetworkError>) -> Void) {
        guard let url = currentWeatherURL(location: location) else {
            completion(.failure(.invalidURL))
            return
        }
        
        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let currentWeather = try JSONDecoder().decode(CurrentWeatherJSONData.self, from: data)
                    completion(.success(currentWeather))
                } catch {
                    completion(.failure(.message(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Retrieves the weather forecast data for a given location.
     - Parameters:
        - location: The CLLocation object representing the location.
        - completion: Completion handler with a `Result` enum indicating success (`ForecastJSONData`) or failure (`NetworkError`).
     */
    func retrieveWeatherForecast(location: CLLocation, completion: @escaping (Result<ForecastJSONData, NetworkError>) -> Void) {
        guard let url = forecastURL(location: location) else {
            completion(.failure(.invalidURL))
            return
        }
        
        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let forecast = try JSONDecoder().decode(ForecastJSONData.self, from: data)
                    completion(.success(forecast))
                } catch {
                    completion(.failure(.message(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension WeatherService {
    /**
     Default live instance of WeatherService using a default NetworkService.
     */
    static var live = WeatherService(networkService: NetworkService())
}
