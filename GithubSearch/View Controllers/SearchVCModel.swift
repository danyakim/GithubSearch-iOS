//
//  SearchVCModel.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Foundation
import UIKit
import Combine

class SearchVCModel<VMType: ResultsVM>: UIViewController,
                                            UIScrollViewDelegate,
                                            UISearchBarDelegate {
  
  // MARK: - UIViews
  private let searchBar = UISearchBar()
  let tableView = UITableView()
  
  // MARK: - Properties
  var viewModel: VMType
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Initializers
  init(viewModel: VMType) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupSearchBar()
    reactToNewResults()
    setupLoadingIndicator()
    viewModel.startReacting()
  }
  
  // MARK: - Private methods
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.anchor(top: view.topAnchor,
                     leading: view.leadingAnchor,
                     bottom: view.bottomAnchor,
                     trailing: view.trailingAnchor)
    tableView.estimatedRowHeight = 88
  }
  
  private func setupSearchBar() {
    navigationItem.titleView = searchBar
    searchBar.delegate = self
  }
  
  private func reactToNewResults() {
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
  
  private func setupLoadingIndicator() {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: 44)
    tableView.tableFooterView = spinner
    tableView.tableFooterView?.isHidden = true
    
    viewModel.isLoading
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
  
  private func presentAlert(message: String) {
    let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
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
