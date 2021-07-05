//
//  UserTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import UIKit
import Combine

class UserTableViewCell: UITableViewCell {
  
  private let imageLoader = ImageLoader()
  private var loader: AnyCancellable?
  
  required init(avatarURL: String,
                name: String) {
    
    super.init(style: .default, reuseIdentifier: nil)
    
    loader = imageLoader.load(from: avatarURL)
      .sink { [weak self] image in
        self?.imageView?.image = image
      }
    textLabel?.text = name
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
