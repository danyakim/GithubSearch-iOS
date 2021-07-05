//
//  RepositoriesCoordinator.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import Foundation
import UIKit

class RepositoriesCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = SearchRepositoriesVC(viewModel: RepositoriesVM())
    vc.coordinator = self
    
    navigationController.tabBarItem.title = "Repositories"
    navigationController.tabBarItem.image = UIImage(systemName: "book.closed.fill")
    
    navigationController.pushViewController(vc, animated: false)
  }
  
  func showDetails(for resultItem: Repository) {
    let vc = DetailsVC(resultItem: resultItem)
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
}
