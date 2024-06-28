//
//  WeatherViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Khagesh Patel on 27/6/24.
//

import Foundation
import CoreLocation

/**
 ViewModel responsible for weather data presentation and interaction
 */
final class WeatherViewModel: ObservableObject {
    
    // MARK: - Properties
        
    // Placeholder for Addresses type (assuming it's properly initialized)
    var addresses = Addresses
    
    // Error message property for showing alert
    @Published var errorMessage: String?
    
    // Display data properties
    @Published var weatherDisplayData: CurrentWeatherDisplayData?
    @Published var forecast: ForecastDisplayData?

    // MARK: - Methods
    
    // Method to retrieve current weather and forecast for a given address
    func retrieveCurrentWeatherAndForecast(address: String) {
        // Convert address to coordinates
        AddressService.live.coordinatesCompletion(address) { [weak self] location, error in
            guard let self = self else { return }
            if let location = location {
                // Retrieve weather and forecast data using obtained location
                self.retrieveCurrentWeather(location: location)
                self.retrieveWeatherForecast(location: location)
            } else if let _ = error {
                self.errorMessage = WeatherString.addressFetchError
            }
        }
    }
    
    // Method to retrieve current weather for a given location
    func retrieveCurrentWeather(location: CLLocation) {
        
        // Fetch current weather data using WeatherService
        WeatherService.live.retrieveCurrentWeather(location: location) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    // Populate weather display data on success
                    self.weatherDisplayData = CurrentWeatherDisplayData(from: weatherData)
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                }
            }
        }
    }
    
    // Method to retrieve weather forecast for a given location
    func retrieveWeatherForecast(location: CLLocation) {
        
        // Fetch weather forecast data using WeatherService
        WeatherService.live.retrieveWeatherForecast(location: location) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    // Populate forecast display data on success
                    self.forecast = ForecastDisplayData(from: data)
                    
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                }
            }
        }
    }
}
