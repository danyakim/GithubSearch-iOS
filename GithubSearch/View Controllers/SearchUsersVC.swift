//
//  SearchUsersVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import UIKit
import Combine

class SearchUsersVC: UIViewController,
                     SearchVCModel {
  
  // MARK: - Properties
  var tableView = UITableView()
  var viewModel: ResultsVM = UsersVM()
  var subscriptions = Set<AnyCancellable>()
  
  var searchBar = UISearchBar()
  
  weak var coordinator: UsersCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    defaultSetup()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(cellClass: UserTableViewCell.self)
  }
  
  func reactToNewResults() {
    guard let viewModel = viewModel as? UsersVM else { fatalError("Wrong View Model") }
    viewModel.results
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.presentAlert(message: error.description)
        }
      } receiveValue: { [weak self] results in
        guard let self = self else { return }
        guard !results.isEmpty else { return self.tableView.reloadData() }
        
        let count = results.count
        if count % 30 == 0 {
          let indexPaths = (count - 30 ... count - 1).reduce([]) { indexes, row in
            return indexes + [IndexPath(row: row, section: 0)]
          }
          self.tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
          let indexPaths = (count - (count % 30) ... count - 1).reduce([]) { indexes, row in
            return indexes + [IndexPath(row: row, section: 0)]
          }
          self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
      }
      .store(in: &subscriptions)
  }
  
}

// MARK: - TableViewDataSource
extension SearchUsersVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = viewModel as? UsersVM else { fatalError("Wrong View Model") }
    return viewModel.results.value.count
  }
  
}

// MARK: - TableViewDelegate
extension SearchUsersVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 66
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel as? UsersVM else { fatalError("Wrong View Model") }
    let user = viewModel.results.value[indexPath.row]
    let cell = tableView.dequeue(cellClass: UserTableViewCell.self, for: indexPath)
    cell.configure(with: UserTableViewCellData(name: user.login, avatarURL: user.avatarURL))
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let viewModel = viewModel as? UsersVM else { fatalError("Wrong View Model") }
    if indexPath.row == viewModel.results.value.count - 1 {
      viewModel.incrementPage()
    }
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
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
  
  // MARK: - ScrollViewDelegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
}
