//
//  WeatherReportView.swift
//  SwiftUIIntergrationProject
//
//  Created by Khagesh Patel on 27/6/24.
//

import SwiftUI

struct WeatherReportView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if let weatherData = viewModel.weatherDisplayData {
                Text(weatherData.nameOfLocationText)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Text(weatherData.currentWeatherText)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

                Text(weatherData.temperatureText)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

            } else {
                Text(WeatherString.noWeatherReportMessage)
                    .foregroundColor(.red)
            }
        }
        .background(Color.clear)
    }
}


#Preview {
    WeatherReportView(viewModel: WeatherViewModel())
}
