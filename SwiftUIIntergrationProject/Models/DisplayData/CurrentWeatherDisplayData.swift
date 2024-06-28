//
//  CurrentWeatherDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/4/24.
//

import Foundation

struct CurrentWeatherDisplayData: Equatable{
  let nameOfLocationText: String
  let currentWeatherText: String
  let temperatureText: String
  let windSpeedText: String
  let windDirectionText: String
}

extension CurrentWeatherDisplayData {
  init(from jsonData: CurrentWeatherJSONData) {
    nameOfLocationText = jsonData.name
    let weatherText = jsonData.weather.first?.description ?? "Not Available"
    currentWeatherText = "\(weatherText)"
    let temperature = jsonData.main.temp.rounded(.towardZero)
    temperatureText = "Current temperature: \(temperature) F"
    let wind = jsonData.wind.speed.rounded(.towardZero)
    let direction = jsonData.wind.direction
    windSpeedText = "Wind: \(wind) mph"
    windDirectionText = "Wind Direction: \(direction)"
  }
}

extension CurrentWeatherDisplayData {
  static func mock(
    location: String = "Tyson's Corner",
    currentWeather: String = "Cloudy",
    temperature: String = "Temperature: 74F",
    windSpeed: String = "Wind: 8 mph",
    windDirection: String = "Wind direction: South"
  ) -> CurrentWeatherDisplayData {
    .init(
      nameOfLocationText: location,
      currentWeatherText: currentWeather,
      temperatureText: temperature,
      windSpeedText: windSpeed,
      windDirectionText: windDirection)
  }
}
