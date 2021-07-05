//
//  UsersVM.swift
//  GithubSearch
//
//  Created by Daniil Kim on 02.07.2021.
//

import Foundation
import Combine

class UsersVM: ResultsVM {
  
  // MARK: - ResultsVM
  typealias GithubResult = User
  var results = CurrentValueSubject<[GithubResult], GithubError>([])
  var search = CurrentValueSubject<String, Never>("")
  var isLoading = PassthroughSubject<Bool, Never>()
  
  var totalCount = 0
  var page = CurrentValueSubject<Int, Never>(1)
  var subscriptions = Set<AnyCancellable>()
  
  let network = GithubAPI()
  
  // MARK: - Methods
  
  func getResults(for string: String, page: Int = 1) {
    network.getUsers(for: string, on: page)
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
  
}
