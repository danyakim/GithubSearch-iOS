//
//  ResultsVM.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Foundation
import Combine

protocol ResultsVM: AnyObject {
  
  // MARK: - Properties
  var search: CurrentValueSubject<String, Never> { get }
  var page: CurrentValueSubject<Int, Never> { get }
  var isLoading: PassthroughSubject<Bool, Never> { get }
  var subscriptions: Set<AnyCancellable> { get set }
  var totalCount: Int { get }
  
  // MARK: - Methods
  
  func eraseResults()
  func count() -> Int
  func startReacting()
  func incrementPage()
  func getResults(for string: String, page: Int)
}

extension ResultsVM {
  
  func startReacting() {
    search
      .dropFirst()
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] searchText in
        guard let self = self else { return }
        
        self.eraseResults()
        if !searchText.isEmpty {
          self.page.send(1)
        }
      }
      .store(in: &subscriptions)
    
    page
      .dropFirst()
      .sink { [weak self] page in
        guard let self = self else { return }
        if page != 1, self.totalCount <= self.count() { return }
        self.isLoading.send(true)
        self.getResults(for: self.search.value, page: page)
      }
      .store(in: &subscriptions)
    
  }
  
  func incrementPage() {
    page.send(page.value + 1)
  }
  
  func getResults(for string: String, page: Int = 1) {
    fatalError("no implementation of that method")
  }
  
}
