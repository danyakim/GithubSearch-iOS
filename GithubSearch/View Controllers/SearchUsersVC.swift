//
//  SearchUsersVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import UIKit
import Combine

class SearchUsersVC: SearchVCModel<UsersVM> {
  
  // MARK: - Properties
  weak var coordinator: UsersCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(cellClass: UserTableViewCell.self)
  }
  
}

// MARK: - TableViewDataSource
extension SearchUsersVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    let user = viewModel.results.value[indexPath.row]
    let cell = tableView.dequeue(cellClass: UserTableViewCell.self, for: indexPath)
    cell.configure(with: UserTableViewCellData(name: user.login, avatarURL: user.avatarURL))
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.results.value.count - 1 {
      viewModel.incrementPage()
    }
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
}
