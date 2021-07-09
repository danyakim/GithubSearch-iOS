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
  
  lazy var tableViewManager = TableViewManager<Repository, RepositoryTableViewCell>(publisher: viewModel.results) { cell, _, repository in
    cell.configure(with: RepositoryTableViewCellData(name: repository.fullName,
                                                     about: repository.itemDescription,
                                                     stars: repository.stargazersCount,
                                                     language: repository.language,
                                                     lastUpdated: repository.updatedAt))
  }
  var viewModel = ResultsVM<Repository>()
  var subscriptions = Set<AnyCancellable>()
      
  weak var coordinator: RepositoriesCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupViewModel()
    setupTableViewManager()
    
    tableView.register(cellClass: RepositoryTableViewCell.self)
  }
  
  func setupTableViewManager() {
    tableViewManager.tableView = tableView
    
    let callbacks = TableViewManager<Repository, RepositoryTableViewCell>.Callbacks { [weak self] repository in
      self?.coordinator?.showDetails(for: repository)
    } onScroll: { [weak self] in
      self?.searchBar.resignFirstResponder()
    } onScrollToEnd: { [weak self] in
      self?.viewModel.nextPage()
    } onReceiveError: { [weak self] error in
      guard let error = error as? GithubError else { return }
      self?.coordinator?.presentAlert(message: error.description)
    }
    tableViewManager.callbacks = callbacks
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
  
}
