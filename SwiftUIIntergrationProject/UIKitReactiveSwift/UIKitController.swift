//
//  UIKitReactiveController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

// TODO: Create UIKit View that either pre-selects address or user enters address, and retrieves current weather plus weather forecast
class UIKitController: UIViewController {
  private lazy var label: UILabel = {
    let label = UILabel()
    label.text = "TODO: Create UIKit View that either pre-selects address or user enters address, and retrieves current weather plus weather forecast"
    label.numberOfLines = 0
    view.addSubview(label)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    label.snp.updateConstraints { make in
      make.leading.equalTo(view).inset(16)
      make.trailing.equalTo(view).inset(16)
      make.centerY.equalTo(view)
    }
      
      // Test the Network Service
      AddressService.live.coordinatesCompletion("8020 Towers Crescent Dr, Tysons, VA 22182") { location, error in
          guard let location else {
              return
          }
          guard let url = currentWeatherURL(location: location) else {
              return
          }
          NetworkService().fetchData(from: url) { response in
              switch response {
              case .success(let data):
                  do {
                      let currentWeather = try JSONDecoder().decode(CurrentWeatherJSONData.self, from: data)
                      print(currentWeather)
                  } catch {
                      print(error)
                  }
              case .failure(let error):
                  print(error)
              }

          }
      }
          
  }
}
