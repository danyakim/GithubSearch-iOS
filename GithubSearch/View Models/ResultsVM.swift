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
  
  @Published private(set) var results = [ResultItem]()
  
  private(set) var search = CurrentValueSubject<String, Never>("")
  private(set) var selectedRow = PassthroughSubject<Int, Never>()
  
  private var totalCount = 0
  private var page = CurrentValueSubject<Int, Never>(1)
  
  private var subscriptions = Set<AnyCancellable>()
  private var network = GithubAPI()
  
  weak var coordinator: MainCoordinator?
  
  // MARK: - Methods
  
  public func startReacting() {
    search
      .dropFirst()
      .filter { !$0.isEmpty }
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] searchText in
        guard let self = self else { return }
        self.results = []
        self.page.send(1)
      }
      .store(in: &subscriptions)
    
    page
      .dropFirst()
      .sink { [weak self] page in
        guard let self = self else { return }
        if page != 1, self.totalCount <= self.results.count { return }
        self.getResults(for: self.search.value, page: page)
      }
      .store(in: &subscriptions)
    
    selectedRow
      .sink { [weak self] row in
        guard let self = self else { return }
        self.coordinator?.showDetails(for: self.results[row])
      }
      .store(in: &subscriptions)
      
  }
  
  public func getResults(for string: String, page: Int = 1) {
    network.getSearchResults(for: string, on: page)
      .sink { completion in
        switch completion {
        case .finished:
          print("Got results")
        case .failure(let error):
          print("Failed fetching results for '\(string)' error: \(error.localizedDescription)")
        }
      } receiveValue: { [weak self] receivedResult in
        guard let self = self,
              let totalCount = receivedResult.totalCount,
              let items = receivedResult.items else { return }
        self.totalCount = totalCount
        self.results += items
      }
      .store(in: &subscriptions)
  }
  
  public func resultHasDescription(at index: Int) -> Bool {
    return results[index].itemDescription != nil
  }
  
  public func incrementPage() {
    page.send(page.value + 1)
  }
  
}
