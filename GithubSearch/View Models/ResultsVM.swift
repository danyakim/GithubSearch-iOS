//
//  ResultsVM.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import Foundation
import Combine

class ResultsVM {
  
  // MARK: - Properties
  
  var results = CurrentValueSubject<[ResultItem], GithubError>([])
  var search = CurrentValueSubject<String, Never>("")
  var isLoading = PassthroughSubject<Bool, Never>()
  
  private var totalCount = 0
  private var page = CurrentValueSubject<Int, Never>(1)
  private var subscriptions = Set<AnyCancellable>()
  private var network = GithubAPI()
  
  // MARK: - Methods
  
  public func startReacting() {
    search
      .dropFirst()
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] searchText in
        guard let self = self else { return }
        
        self.results.value = []
        if !searchText.isEmpty {
          self.page.send(1)
        }
      }
      .store(in: &subscriptions)
    
    page
      .dropFirst()
      .sink { [weak self] page in
        guard let self = self else { return }
        if page != 1, self.totalCount <= self.results.value.count { return }
        self.isLoading.send(true)
        self.getResults(for: self.search.value, page: page)
      }
      .store(in: &subscriptions)
      
  }
  
  public func getResults(for string: String, page: Int = 1) {
    network.getSearchResults(for: string, on: page)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.results.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] receivedResult in
        guard let self = self,
              let totalCount = receivedResult.totalCount,
              let items = receivedResult.items else { return }
        self.totalCount = totalCount
        self.results.value += items
        self.isLoading.send(false)
      }
      .store(in: &subscriptions)
  }
  
  public func resultHasDescription(at index: Int) -> Bool {
    return results.value[index].itemDescription != nil
  }
  
  public func incrementPage() {
    page.send(page.value + 1)
  }
  
}
