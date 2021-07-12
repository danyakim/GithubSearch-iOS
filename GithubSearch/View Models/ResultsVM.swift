//
//  ResultsVMProtocol.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Foundation
import Combine

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
  }
  
  // MARK: - Methods
  func getResults(for string: String, page: Int = 1) {
    network.getResults(resultType: Result.self, for: string, on: page)
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

  func startReacting() {
    page
      .dropFirst()
      .sink { [weak self] page in
        guard let self = self else { return }
        if page != 1,
           self.totalCount <= self.results.value.count { return }
        self.isLoading.send(true)
      }
      .store(in: &subscriptions)
    
    search
      .handleEvents(receiveOutput: { [weak self] _ in
        self?.results.value = []
      })
      .filter({ !$0.isEmpty })
      .combineLatest(page)
      .sink(receiveValue: { search, page in
        self.getResults(for: search, page: page)
      })
      .store(in: &subscriptions)
  }
  
  func nextPage() {
    page.value += 1
  }
  
}
