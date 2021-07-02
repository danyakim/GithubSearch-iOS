//
//  ImageLoader.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import Foundation
import UIKit
import Combine

class ImageLoader {
  
  func load(from urlString: String) -> AnyPublisher<UIImage, Never> {
    guard let url = URL(string: urlString) else { return Empty().eraseToAnyPublisher() }
    return URLSession.shared
      .dataTaskPublisher(for: url)
      .map { UIImage(data: $0.data) ?? UIImage() }
      .receive(on: DispatchQueue.main)
      .replaceError(with: UIImage())
      .eraseToAnyPublisher()
  }
  
}
