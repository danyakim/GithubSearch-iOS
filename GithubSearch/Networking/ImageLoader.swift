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
  
  @Published var image: UIImage?
  private var subscription: AnyCancellable?
  
  func load(from urlString: String) {
    guard let url = URL(string: urlString) else { return }
    subscription = URLSession.shared
      .dataTaskPublisher(for: url)
      .map(\.data )
      .map { UIImage(data: $0) ?? UIImage() }
      .receive(on: DispatchQueue.main)
      .replaceError(with: UIImage())
      .sink { [weak self] image in
        self?.image = image
      }
  }
  
}
