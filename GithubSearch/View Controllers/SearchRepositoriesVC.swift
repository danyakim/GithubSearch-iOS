//
//  SearchTableVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit
import Combine

class SearchRepositoriesVC: UIViewController,
                            SearchVCProtocol {
  
  // MARK: - Properties
  var searchBar = UISearchBar()
  var tableView = UITableView()
  
  var viewModel = ResultsVM<Repository>()
  var subscriptions = Set<AnyCancellable>()
  
  weak var coordinator: RepositoriesCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupViewModel()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(cellClass: RepositoryTableViewCell.self)
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
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let repository = viewModel.results.value[indexPath.row]
    let cell = tableView.dequeue(cellClass: RepositoryTableViewCell.self, for: indexPath)
    cell.configure(with: RepositoryTableViewCellData(name: repository.fullName,
                                                     about: repository.itemDescription,
                                                     stars: repository.stargazersCount,
                                                     language: repository.language,
                                                     lastUpdated: repository.updatedAt))
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let result = viewModel.results.value[indexPath.row]
    coordinator?.showDetails(for: result)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.results.value.count - 1 {
      viewModel.nextPage()
    }
  }
  
}

extension SearchRepositoriesVC: UISearchBarDelegate {
  // MARK: - SearchBarDelegate
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.search.send(searchText)
  }
  
  // MARK: - ScrollViewDelegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
  
}
