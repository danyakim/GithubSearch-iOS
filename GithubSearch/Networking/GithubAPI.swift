//
//  GithubAPI.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import Foundation
import Combine

enum GithubError: Error, CustomStringConvertible {
  case badURL(String)
  case network(String)
  case parsing(String)
  case unknown
  
  var description: String {
    switch self {
    case .badURL(let string):
      return "Couldn't form URL from string: \(string)"
    case .network(let string):
      return "Request to API failed\(string)"
    case .parsing(let string):
      return "Failed parsing response:\(string)"
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
  public func getSearchResults(for string: String, on page: Int) -> Future<SearchResult, GithubError> {
    let urlString = baseURL + "/search/repositories?q=\(string)&page=\(String(page))"
    
    guard let url = URL(string: urlString) else {
      return Future { promise in
        promise(.failure(GithubError.badURL(urlString)))
      }
    }
    return Future { promise in
      URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: SearchResult.self, decoder: JSONDecoder())
//        .print()
        .sink { completion in
          if case let .failure(error) = completion {
            switch error {
            case let urlError as URLError:
              promise(.failure(GithubError.network(urlError.localizedDescription)))
            case let decodingError as DecodingError:
              promise(.failure(GithubError.parsing(decodingError.localizedDescription)))
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
