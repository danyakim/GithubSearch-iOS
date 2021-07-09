//
//  SearchUsersVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import UIKit
import Combine

class SearchUsersVC: UIViewController,
                     SearchVCProtocol {  
  
  // MARK: - Properties
  var searchBar = UISearchBar()
  var tableView = UITableView()
  
  lazy var tableViewManager = TableViewManager<User, UserTableViewCell>(publisher: viewModel.results) { cell, _, user in
    cell.configure(with: UserTableViewCellData(name: user.login,
                                               avatarURL: user.avatarURL))
  }
  var viewModel = ResultsVM<User>()
  var subscriptions = Set<AnyCancellable>()
  
  weak var coordinator: UsersCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupViewModel()
    setupTableViewManager()
    
    tableView.register(cellClass: UserTableViewCell.self)
  }
  
  func setupTableViewManager() {
    tableViewManager.tableView = tableView
    
    let callbacks = TableViewManager<User, UserTableViewCell>.Callbacks(onSelectCell: nil) { [weak self] in
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

extension SearchUsersVC: UISearchBarDelegate {
  // MARK: - SearchBarDelegate
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.search.send(searchText)
  }
  
}
