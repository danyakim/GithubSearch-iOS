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
}
