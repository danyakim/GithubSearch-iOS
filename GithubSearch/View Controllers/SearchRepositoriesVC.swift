//
//  SearchTableVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit
import Combine

class SearchRepositoriesVC: UIViewController,
                            SearchVCModel {
  // MARK: - Properties
  var tableView = UITableView()
  var viewModel: ResultsVM = RepositoriesVM()
  var subscriptions = Set<AnyCancellable>()
  
  var searchBar = UISearchBar()
  
  weak var coordinator: RepositoriesCoordinator?
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    defaultSetup()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(cellClass: RepositoryTableViewCell.self)
  }
 
  func reactToNewResults() {
    guard let viewModel = viewModel as? RepositoriesVM else { fatalError("Wrong View Model") }
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
extension SearchRepositoriesVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = viewModel as? RepositoriesVM else { fatalError("Wrong View Model") }
    return viewModel.results.value.count
  }
  
}

// MARK: - TableViewDelegate
extension SearchRepositoriesVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let viewModel = viewModel as? RepositoriesVM else { fatalError("Wrong View Model") }
    return viewModel.resultHasDescription(at: indexPath.row) ? 88 : 66
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel as? RepositoriesVM else { fatalError("Wrong View Model") }
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
    guard let viewModel = viewModel as? RepositoriesVM else { fatalError("Wrong View Model") }
    tableView.deselectRow(at: indexPath, animated: true)
    
    let result = viewModel.results.value[indexPath.row]
    coordinator?.showDetails(for: result)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let viewModel = viewModel as? RepositoriesVM else { fatalError("Wrong View Model") }
    if indexPath.row == viewModel.results.value.count - 1 {
      viewModel.incrementPage()
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
