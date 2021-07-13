//
//  ResultsVMProtocol.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Combine
import Foundation

class ResultsVM<Result: Codable> {
  
  // MARK: - Properties
  private(set) var results = CurrentValueSubject<[Result], Error>([])
  private(set) var isLoading = PassthroughSubject<Bool, Never>()
  private var search: AnyPublisher<String, Never>
  private var page = CurrentValueSubject<Int, Never>(1)
  private var totalCount = 0
  private var subscriptions = Set<AnyCancellable>()
  
  private let network = GithubAPI()
  
  // MARK: - Initializers
  init(searchPublisher: AnyPublisher<String, Never>) {
    self.search = searchPublisher
    
    setupSearch()
  }
  
  // MARK: - Methods
  func nextPage() {
    guard self.totalCount > self.results.value.count else { return }
    page.value += 1
  }
  
  // MARK: - Private Methods
  private func setupSearch() {
    search
      .handleEvents(receiveOutput: { [weak self] _ in
        self?.results.value = []
      })
      .filter({ !$0.isEmpty })
      .handleEvents(receiveOutput: { [weak self] _ in
        if self?.page.value != 1 {
          self?.page.send(1)
        }
      })
      .combineLatest(page)
      .removeDuplicates(by: { previous, current in
        return previous.0 == current.0 && current.1 == 1
      })
      .flatMap({ [weak self] (search, page) -> AnyPublisher<SearchResult<Result>, GithubError> in
        guard let self = self else { fatalError("no self in ", file: #function) }
        self.isLoading.send(true)
        return self.network.getResults(resultType: Result.self, for: search, on: page)
      })
      .catch({ [weak self] error -> AnyPublisher<SearchResult<Result>, Never> in
        self?.isLoading.send(false)
        self?.results.send(completion: .failure(error))
        return Just(SearchResult<Result>(totalCount: 0, items: []))
          .eraseToAnyPublisher()
      })
      .compactMap { [weak self] (searchResult) -> [Result] in
        guard let self = self,
              let totalCount = searchResult.totalCount,
              let items = searchResult.items else { return [] }
        self.totalCount = totalCount
        self.isLoading.send(false)
        return self.results.value + items
      }
      .assign(to: \.value, on: results)
      .store(in: &subscriptions)
  }
  
//  private func getResults(for string: String, page: Int = 1) {
//    self.isLoading.send(true)
//    network.getResults(resultType: Result.self, for: string, on: page)
//      .sink { [weak self] completion in
//        if case let .failure(error) = completion {
//          self?.isLoading.send(false)
//          self?.results.send(completion: .failure(error))
//        }
//      } receiveValue: { [weak self] receivedResult in
//        guard let self = self,
//              let totalCount = receivedResult.totalCount,
//              let items = receivedResult.items else { return }
//        self.totalCount = totalCount
//        self.results.value += items
//        self.isLoading.send(false)
//      }
//      .store(in: &subscriptions)
//  }
//
}
