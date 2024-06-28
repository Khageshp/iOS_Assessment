//
//  SwiftUIMixView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import SwiftUI

// TODO: Create SwiftUI View that either pre-selects address or user enters address, and retrieves current weather plus weather forecast
struct SwiftUIView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @State private var showingAlert = false

    var body: some View {
        VStack {
            AddressListView(viewModel: viewModel)
            WeatherReportView(viewModel: viewModel)
            ForecastListView(viewModel: viewModel)
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)) // Apply red background color
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(WeatherString.errorTitle),
                message: Text(viewModel.errorMessage ?? WeatherString.errorMessageDefault),
                dismissButton: .default(Text(WeatherString.okButtonTitle)) {
                    showingAlert = false
                    viewModel.errorMessage = nil
                }
            )
        }
        .onChange(of: viewModel.errorMessage) { _ , newValue in
            showingAlert = newValue != nil
        }

    }
}
