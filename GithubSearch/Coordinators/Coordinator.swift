//
//  Coordinator.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import Foundation
import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }
  
  func start()
  
  func presentAlert(message: String, title: String, actionTitle: String)
}

extension Coordinator {
  
  func presentAlert(message: String, title: String = "Oops", actionTitle: String = "Ok") {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
    alert.addAction(action)
    navigationController.present(alert, animated: true, completion: nil)
  }
  
}
