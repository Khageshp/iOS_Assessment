//
//  ForecastListView.swift
//  SwiftUIIntergrationProject
//
//  Created by Khagesh Patel on 27/6/24.
//

import SwiftUI
import Combine

struct ForecastListView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.forecast?.forecastItems ?? [ForecastItemDisplayData](), id: \.self) { item in
                    ForecastRowView(data: item)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure the VStack is leading aligned
            .padding()
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct ForecastRowView: View {
    var data: ForecastItemDisplayData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(data.timeDateText)
                .font(.headline)
                .multilineTextAlignment(.leading)

            Text(data.temperatureText)
                .font(.subheadline)
                .multilineTextAlignment(.leading)

            Text(data.weatherText)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            
            Divider()
                .padding(.vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ForecastListView(viewModel: WeatherViewModel())
}
