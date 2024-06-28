//
//  AddressListView.swift
//  SwiftUIIntergrationProject
//
//  Created by Khagesh Patel on 27/6/24.
//

import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.addresses.indices, id: \.self) { index in
                    AddressButtonView(address: "\(WeatherString.addressTitle) \(index + 1)") {
                        viewModel.retrieveCurrentWeatherAndForecast(address: viewModel.addresses[index])
                    }
                }
            }
            .padding()
        }
    }
}

struct AddressButtonView: View {
    let address: String
    let action: () -> Void
    
    var body: some View {
        Text(address)
            .onTapGesture {
                action()
            }
            .padding(10)
            .foregroundColor(Color.blue.opacity(0.8))
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
    }
}

#Preview {
    AddressListView(viewModel: WeatherViewModel())
}
