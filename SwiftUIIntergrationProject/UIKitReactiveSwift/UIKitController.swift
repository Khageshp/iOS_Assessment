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
  }
}
