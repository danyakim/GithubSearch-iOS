//
//  SearchVCModel.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Foundation
import UIKit
import Combine

protocol SearchVCProtocol: UIViewController,
                           UISearchBarDelegate {
  
  // MARK: - Properties
  var searchBar: UISearchBar { get }
  var tableView: UITableView { get }
  
  associatedtype Result: Codable
  var viewModel: ResultsVM<Result> { get }
  var subscriptions: Set<AnyCancellable> { get set }
  
  // MARK: - Methods
  func setupViews()
  func setupTableView()
  func setupSearchBar()
  
  func bindVMAndManager()
  func setupViewModel()
  func setupTableViewManager()
}

// MARK: - Default Implementation
extension SearchVCProtocol {
  
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
  
  func bindVMAndManager() {
    setupTableViewManager()
    setupViewModel()
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
  
}
