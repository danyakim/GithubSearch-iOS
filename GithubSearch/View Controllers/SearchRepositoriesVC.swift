//
//  SearchTableVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit
import Combine

class SearchRepositoriesVC: SearchVCModel<RepositoriesVM> {
  weak var coordinator: RepositoriesCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
}

// MARK: - TableViewDataSource
extension SearchRepositoriesVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewModel.results.value.count
  }
  
}

// MARK: - TableViewDelegate
extension SearchRepositoriesVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.resultHasDescription(at: indexPath.row) ? 88 : 66
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let result = viewModel.results.value[indexPath.row]
    let cell = ResultTableViewCell(name: result.fullName,
                                   about: result.itemDescription,
                                   stars: result.stargazersCount,
                                   language: result.language,
                                   lastUpdated: result.updatedAt)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let result = viewModel.results.value[indexPath.row]
    coordinator?.showDetails(for: result)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.results.value.count - 1 {
      viewModel.incrementPage()
    }
  }
  
}