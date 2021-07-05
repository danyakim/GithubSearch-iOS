//
//  GithubAPI.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import Foundation
import Combine

enum GithubError: Error, CustomStringConvertible {
  case badURL
  case network
  case parsing
  case unknown
  
  var description: String {
    switch self {
    case .badURL:
      return "Couldn't form URL from string"
    case .network:
      return "Network Error"
    case .parsing:
      return "Failed parsing response"
    default:
      return "Unknown Error"
    }
  }
}

class GithubAPI {
  
  // MARK: - Properties
  private let baseURL = "https://api.github.com"
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Public methods
  public func getRepositories(for string: String, on page: Int)
  -> Future<SearchResult<Repository>, GithubError> {
    let urlString = baseURL + "/search/repositories?q=\(string)&page=\(String(page))"
    
    return makeRequest(for: urlString)
  }
  
  public func getUsers(for string: String, on page: Int)
  -> Future<SearchResult<User>, GithubError> {
    let urlString = baseURL + "/search/users?q=\(string)&page=\(String(page))"
    
    return makeRequest(for: urlString)
  }
  
  // MARK: - Private Methods
  private func makeRequest<T: Codable>(for urlString: String) -> Future<SearchResult<T>, GithubError> {
    return Future { promise in
      guard let url = URL(string: urlString) else {
        return promise(.failure(GithubError.badURL))
      }
      URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: SearchResult.self, decoder: JSONDecoder())
        .sink { completion in
          if case let .failure(error) = completion {
            switch error {
            case is URLError:
              promise(.failure(GithubError.network))
            case is DecodingError:
              promise(.failure(GithubError.parsing))
            default:
              promise(.failure(GithubError.unknown))
            }
          }
        } receiveValue: { result in
          promise(.success(result))
        }
        .store(in: &self.subscriptions)
    }
  }
  
}
