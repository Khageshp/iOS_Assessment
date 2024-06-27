//
//  WeatherViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Khagesh Patel on 27/6/24.
//

import Foundation
import CoreLocation

/**
 Protocol for handling UI error messages.
 */
protocol WeatherViewModelDelegate: AnyObject {
    func showError(message: String)
}

/**
 ViewModel responsible for weather data presentation and interaction
 */
final class WeatherViewModel {
    
    // MARK: - Properties
    
    // Delegate to handle error messages
    var delegate: WeatherViewModelDelegate?
    
    // Placeholder for Addresses type (assuming it's properly initialized)
    var addresses = Addresses
    
    // Display data properties
    var weatherDisplayData: CurrentWeatherDisplayData?
    var forecast: ForecastDisplayData?

    // Event handlers for notifying UI updates
    var weatherEventHandler: ((_ event: WatherEvent) -> Void)?
    var forecastEventHandler: ((_ event: ForecastEvent) -> Void)?

    // MARK: - Methods
    
    // Method to retrieve current weather and forecast for a given address
    func retrieveCurrentWeatherAndForecast(address: String)  {
        // Convert address to coordinates
        AddressService.live.coordinatesCompletion(address) { location, error in
            if let location = location {
                // Retrieve weather and forecast data using obtained location
                self.retrieveCurrentWeather(location: location)
                self.retrieveWeatherForecast(location: location)
            } else if let error = error {
                // Notify delegate of conversion error
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
    // Method to retrieve current weather for a given location
    func retrieveCurrentWeather(location: CLLocation) {
        // Notify UI that data loading is in progress
        self.weatherEventHandler?(.loading)
        
        // Fetch current weather data using WeatherService
        WeatherService.live.retrieveCurrentWeather(location: location) { [self] result in
            // Notify UI that data loading has stopped
            self.weatherEventHandler?(.stopLoading)
            
            switch result {
            case .success(let weatherData):
                // Populate weather display data on success
                weatherDisplayData = CurrentWeatherDisplayData(from: weatherData)
                // Notify UI that weather data has been loaded
                self.weatherEventHandler?(.dataLoaded)
                
            case .failure(let error):
                // Notify delegate of weather data retrieval error
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
    // Method to retrieve weather forecast for a given location
    func retrieveWeatherForecast(location: CLLocation) {
        // Notify UI that data loading is in progress
        self.forecastEventHandler?(.loading)
        
        // Fetch weather forecast data using WeatherService
        WeatherService.live.retrieveWeatherForecast(location: location) { [self] result in
            // Notify UI that data loading has stopped
            self.forecastEventHandler?(.stopLoading)
            
            switch result {
            case .success(let data):
                // Populate forecast display data on success
                forecast = ForecastDisplayData(from: data)
                // Notify UI that forecast data has been loaded
                self.forecastEventHandler?(.dataLoaded)
                
            case .failure(let error):
                // Notify delegate of forecast data retrieval error
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
}

// Extension to declare nested enums for weather and forecast events
extension WeatherViewModel {
    
    // Enum defining events related to current weather
    enum WatherEvent {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
    
    // Enum defining events related to weather forecast
    enum ForecastEvent {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
