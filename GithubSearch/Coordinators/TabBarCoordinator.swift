//
//  MainCoordinator.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    navigationController.navigationBar.isHidden = true
    let tabBarController = UITabBarController()
    
    for coordinator in childCoordinators {
      coordinator.start()
    }
    
    tabBarController.viewControllers = childCoordinators.reduce([], { childViews, coordinator in
      return childViews + [coordinator.navigationController]
    })
    
    navigationController.viewControllers = [tabBarController]
  }
  
}
