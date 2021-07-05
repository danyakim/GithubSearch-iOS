//
//  UsersCoordinator.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import Foundation
import UIKit

class UsersCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = SearchUsersVC(viewModel: UsersVM())
    vc.coordinator = self
    
    navigationController.tabBarItem.title = "Users"
    navigationController.tabBarItem.image = UIImage(systemName: "person.fill")
    
    navigationController.pushViewController(vc, animated: false)
  }
  
}
