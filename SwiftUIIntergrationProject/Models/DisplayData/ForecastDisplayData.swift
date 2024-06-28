//
//  ForecastDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/4/24.
//

import Foundation

struct ForecastDisplayData: Equatable{
  let forecastItems: [ForecastItemDisplayData]
}

struct ForecastItemDisplayData: Equatable, Identifiable, Hashable {
  let id: String
  
  let timeDateText: String
  let temperatureText: String
  let weatherText: String
  let windSpeedText: String
  let windDirectionText: String
  let rainText: String?
}

extension ForecastDisplayData {
  init(from jsonData: ForecastJSONData){
    forecastItems = jsonData.list.map(ForecastItemDisplayData.init)
  }
}

extension ForecastItemDisplayData {
  init(from listItem: List) {
    timeDateText = listItem.displayDate
    let temperature = listItem.temperatures.temp.formattedRoundedWholeNumber()
    temperatureText = "Temperature: \(temperature)F"
    let weather = listItem.weather.first?.description ?? "Not available"
    weatherText = "Weather: \(weather)"
    let wind = listItem.wind.speed.formattedRoundedWholeNumber()
    windSpeedText = "Wind: \(wind) mph"
    windDirectionText = "Wind direction: \(listItem.wind.direction)"
    if let rain = listItem.rain {
      rainText = "Rain: \(rain.the3H.formattedRoundedWholeNumber()) inches"
    } else {
      rainText = .none
    }
    id = UUID().uuidString
  }
}
