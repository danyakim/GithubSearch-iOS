//
//  SearchVCModel.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Foundation
import UIKit
import Combine

protocol SearchVCModel: UIViewController,
                        UISearchBarDelegate {
  
  // MARK: - Properties
  var searchBar: UISearchBar { get }
  var tableView: UITableView { get }
  var subscriptions: Set<AnyCancellable> { get set }
  
  // MARK: - Methods
  func setupViewModel()
  func setupViews()
  func setupTableView()
  func setupSearchBar()
  func reactToNewResults()
  func setupLoadingIndicator()
  func showLoadingIndicator(_ shouldShow: Bool)
  func presentAlert(message: String)
  
}

// MARK: - Default Implementation
extension SearchVCModel {
  
  func setupViews() {
    setupTableView()
    setupSearchBar()
    reactToNewResults()
    setupLoadingIndicator()
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
  
  func setupLoadingIndicator() {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: 44)
    tableView.tableFooterView = spinner
    tableView.tableFooterView?.isHidden = true
  }
  
  func showLoadingIndicator(_ shouldShow: Bool) {
    if shouldShow {
      tableView.tableFooterView?.isHidden = false
    } else {
      tableView.tableFooterView?.isHidden = true
    }
  }
  
  func presentAlert(message: String) {
    let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}
