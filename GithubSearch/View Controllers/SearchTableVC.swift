//
//  SearchTableVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit
import Combine

class SearchTableVC: UITableViewController {
  
  // MARK: - UIViews
  private let searchBar = UISearchBar()
  
  // MARK: - Properties
  private let viewModel = ResultsVM()
  private var subscriptions = Set<AnyCancellable>()
  
  weak var coordinator: MainCoordinator?
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.coordinator = coordinator
    
    setupSearchBar()
    reloadTableViewOnResult()
    setupLoadingIndicator()
    viewModel.startReacting()
  }
  
  // MARK: - Private methods
  private func setupSearchBar() {
    navigationItem.titleView = searchBar
    searchBar.delegate = self
  }
  
  private func reloadTableViewOnResult() {
    viewModel.$results
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.tableView.reloadData()
      }
      .store(in: &subscriptions)
  }
  
  private func setupLoadingIndicator() {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: 44)
    tableView.tableFooterView = spinner
    
    viewModel.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] shouldLoad in
        self?.showLoadingIndicator(shouldLoad)
      }
      .store(in: &subscriptions)
  }
  
  private func showLoadingIndicator(_ shouldShow: Bool) {
    if shouldShow {
      tableView.tableFooterView?.isHidden = false
    } else {
      tableView.tableFooterView?.isHidden = true
    }
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return viewModel.results.count
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.resultHasDescription(at: indexPath.row) ? 88 : 66
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let result = viewModel.results[indexPath.row]
    let cell = ResultTableViewCell(name: result.fullName,
                                   about: result.itemDescription,
                                   stars: result.stargazersCount,
                                   language: result.language,
                                   lastUpdated: result.updatedAt)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.selectedRow.send(indexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.results.count - 1 {
      viewModel.incrementPage()
    }
  }
  
  // MARK: - scrollView
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
}

extension SearchTableVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.search.send(searchText)
  }
  
}
