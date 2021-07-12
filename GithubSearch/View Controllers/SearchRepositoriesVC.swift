//
//  SearchTableVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit
import Combine

class SearchRepositoriesVC: UIViewController {
  
  // MARK: - Properties
  private var searchBar = UISearchBar()
  private var tableView = UITableView()
  private var search = PassthroughSubject<String, Never>()
  private var subscriptions = Set<AnyCancellable>()
  
  private lazy var viewModel = ResultsVM<Repository>(searchPublisher: search
                                                      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                                                      .removeDuplicates()
                                                      .eraseToAnyPublisher())
  private lazy var tableViewManager = TableViewManager<Repository, RepositoryTableViewCell>(publisher: viewModel.results) { cell, _, repository in
    cell.configure(with: RepositoryTableViewCellData(name: repository.fullName,
                                                     about: repository.itemDescription,
                                                     stars: repository.stargazersCount,
                                                     language: repository.language,
                                                     lastUpdated: repository.updatedAt))
  }
  
  weak var coordinator: RepositoriesCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupViewModel()
    setupTableViewManager()
    
    tableView.register(cellClass: RepositoryTableViewCell.self)
  }
  
  func setupViews() {
    setupTableView()
    setupSearchBar()
    tableView.setupLoadingIndicator()
  }
  
  func setupTableView() {
    view.addSubview(tableView)
    tableView.anchor(top: view.topAnchor,
                     leading: view.leadingAnchor,
                     bottom: view.bottomAnchor,
                     trailing: view.trailingAnchor)
    tableView.estimatedRowHeight = 88
  }
  
  func setupSearchBar() {
    navigationItem.titleView = searchBar
    searchBar.delegate = self
  }
  
  func setupViewModel() {
    viewModel.startReacting()
    
    viewModel.isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] shouldLoad in
        self?.tableView.showLoadingIndicator(shouldLoad)
      }
      .store(in: &subscriptions)
  }
  
  func setupTableViewManager() {
    tableViewManager.tableView = tableView
    
    tableViewManager.callbacks.onSelectCell = { [weak self] repository in
      self?.coordinator?.showDetails(for: repository)
    }
    tableViewManager.callbacks.onScroll = { [weak self] in
      self?.searchBar.resignFirstResponder()
    }
    tableViewManager.callbacks.onScrollToEnd = { [weak self] in
      self?.viewModel.nextPage()
    }
    tableViewManager.callbacks.onReceiveError = { [weak self] error in
      self?.viewModel.isLoading.send(false)
      guard let error = error as? GithubError else { return }
      self?.coordinator?.presentAlert(message: error.description)
    }
  }
  
}

extension SearchRepositoriesVC: UISearchBarDelegate {
  // MARK: - SearchBarDelegate
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    search.send(searchText)
  }
  
}
