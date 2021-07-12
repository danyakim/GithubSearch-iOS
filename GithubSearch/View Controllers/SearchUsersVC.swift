//
//  SearchUsersVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import UIKit
import Combine

class SearchUsersVC: UIViewController {
  
  // MARK: - Properties
  private var searchBar = UISearchBar()
  private var tableView = UITableView()
  private var subscriptions = Set<AnyCancellable>()
  private var search = PassthroughSubject<String, Never>()
  
  private lazy var viewModel = ResultsVM<User>(searchPublisher: search
                                                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                                                .removeDuplicates()
                                                .eraseToAnyPublisher())
  private lazy var tableViewManager = TableViewManager<User, UserTableViewCell>(publisher: viewModel.results) { cell, _, user in
    cell.configure(with: UserTableViewCellData(name: user.login,
                                               avatarURL: user.avatarURL))
  }
  
  weak var coordinator: UsersCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    reactToLoading()
    setupTableViewManager()
    
    tableView.register(cellClass: UserTableViewCell.self)
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
    tableView.estimatedRowHeight = 66
  }
  
  func setupSearchBar() {
    navigationItem.titleView = searchBar
    searchBar.delegate = self
  }
  
  func reactToLoading() {
    viewModel.isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] shouldLoad in
        self?.tableView.showLoadingIndicator(shouldLoad)
      }
      .store(in: &subscriptions)
  }
  
  func setupTableViewManager() {
    tableViewManager.tableView = tableView
    
    tableViewManager.callbacks.onScroll = { [weak self] in
      self?.searchBar.resignFirstResponder()
    }
    tableViewManager.callbacks.onScrollToEnd = { [weak self] in
      self?.viewModel.nextPage()
    }
    tableViewManager.callbacks.onReceiveError = { [weak self] error in
      guard let error = error as? GithubError else { return }
      self?.coordinator?.presentAlert(message: error.description)
    }
    
    tableViewManager.cellHeight = 66
  }
  
}

// MARK: - SearchBarDelegate
extension SearchUsersVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    search.send(searchText)
  }
  
}
