//
//  TableViewManager.swift
//  GithubSearch
//
//  Created by Daniil Kim on 08.07.2021.
//

import Foundation
import UIKit
import Combine

class TableViewManager<Item: Codable, CellClass: UITableViewCell>: NSObject,
                                                                   UITableViewDelegate,
                                                                   UITableViewDataSource {
  
  // MARK: - Callbacks
  struct Callbacks {
    var onSelectCell: ((Item) -> Void)?
    var onScroll: (() -> Void)?
    var onScrollToEnd: (() -> Void)?
    var onReceiveError: ((Error) -> Void)?
  }
  
  // MARK: - Properties
  var tableView: UITableView? {
    didSet {
      guard let tableView = tableView else { return }
      tableView.delegate = self
      tableView.dataSource = self
    }
  }
  let configureCell: (CellClass, IndexPath, Item) -> Void
  var callbacks = Callbacks()
  
  var elements: CurrentValueSubject<[Item], Error>
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Initializers
  init(publisher: CurrentValueSubject<[Item], Error>, configureCell: @escaping (CellClass, IndexPath, Item) -> Void) {
    self.elements = publisher
    self.configureCell = configureCell
    super.init()
    reactToNewResults()
  }
  
  // MARK: - Methods
  private func reactToNewResults() {
    elements
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.callbacks.onReceiveError?(error)
        }
      } receiveValue: { [weak self] results in
        guard let self = self else { return }
        guard !results.isEmpty else {
          self.tableView?.reloadData()
          return
        }
        
        let count = results.count
        if count % 30 == 0 {
          let indexPaths = (count - 30 ... count - 1).reduce([]) { indexes, row in
            return indexes + [IndexPath(row: row, section: 0)]
          }
          self.tableView?.insertRows(at: indexPaths, with: .automatic)
        } else {
          let indexPaths = (count - (count % 30) ... count - 1).reduce([]) { indexes, row in
            return indexes + [IndexPath(row: row, section: 0)]
          }
          self.tableView?.insertRows(at: indexPaths, with: .automatic)
        }
      }
      .store(in: &subscriptions)
  }
  
  // MARK: - TableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.value.count
  }
  
  // MARK: - TableViewDelegate
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(cellClass: CellClass.self, for: indexPath)
    let item = elements.value[indexPath.row]
    configureCell(cell, indexPath, item)
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if indexPath.row == elements.value.count - 1 {
      callbacks.onScrollToEnd?()
    }
  }
  
  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard callbacks.onSelectCell != nil else { return nil }
    return indexPath
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let element = elements.value[indexPath.row]
    callbacks.onSelectCell?(element)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    callbacks.onScroll?()
  }
  
}
