//
//  GithubAPI.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import Foundation
import Combine

enum GithubResult {
  case user
  case repository
}

enum GithubError: Error, CustomStringConvertible {
  case badURL
  case network
  case parsing
  case unknown
  case unsupportedReturnType
  
  var description: String {
    switch self {
    case .badURL:
      return "Couldn't form URL from string"
    case .network:
      return "Network Error"
    case .parsing:
      return "Failed parsing response"
    case .unsupportedReturnType:
      return "Result type is unsupported"
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
  public func getResults<T>(resultType: T.Type, for string: String, on page: Int)
  -> Future<SearchResult<T>, GithubError> {
    return Future { [weak self] promise in
      guard let self = self else { return }
      
      let urlString: String
      switch resultType.self {
      case is User.Type:
        urlString = self.baseURL + "/search/users?q=\(string)&page=\(String(page))"
      case is Repository.Type:
        urlString = self.baseURL + "/search/repositories?q=\(string)&page=\(String(page))"
      default:
        return promise(.failure(GithubError.unsupportedReturnType))
      }
      
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
  
//  public func getUsers(for string: String, on page: Int)
//  -> Future<SearchResult<User>, GithubError> {
//    let urlString = baseURL + "/search/users?q=\(string)&page=\(String(page))"
//
//    return makeRequest(for: urlString)
//  }
  
  // MARK: - Private Methods
//  private func makeRequest<T: Codable>(for urlString: String) -> Future<SearchResult<T>, GithubError> {
//    return Future { promise in
//      guard let url = URL(string: urlString) else {
//        return promise(.failure(GithubError.badURL))
//      }
//      URLSession.shared
//        .dataTaskPublisher(for: url)
//        .map(\.data)
//        .decode(type: SearchResult.self, decoder: JSONDecoder())
//        .sink { completion in
//          if case let .failure(error) = completion {
//            switch error {
//            case is URLError:
//              promise(.failure(GithubError.network))
//            case is DecodingError:
//              promise(.failure(GithubError.parsing))
//            default:
//              promise(.failure(GithubError.unknown))
//            }
//          }
//        } receiveValue: { result in
//          promise(.success(result))
//        }
//        .store(in: &self.subscriptions)
//    }
//  }
  
}
