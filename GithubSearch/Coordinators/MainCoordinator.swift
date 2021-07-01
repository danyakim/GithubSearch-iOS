//
//  MainCoordinator.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = SearchTableVC()
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: false)
  }
  
  func showDetails(for resultItem: ResultItem) {
    let vc = DetailsVC(resultItem: resultItem)
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
}
