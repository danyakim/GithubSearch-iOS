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
    
    textLabel?.text = name
    
    setupViews()
    imageView?.image = UIImage(systemName: "person.fill")
    loader = imageLoader.load(from: avatarURL)
      .sink { [weak self] image in
        self?.imageView?.image = image
      }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    imageView?.anchor(top: contentView.topAnchor,
                      leading: contentView.leadingAnchor,
                      bottom: contentView.bottomAnchor,
                      padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0),
                      size: CGSize(width: 58, height: 58))
    imageView?.layer.cornerRadius = 5
    imageView?.layer.masksToBounds = true
    
    textLabel?.anchor(leading: imageView?.trailingAnchor,
                      centerY: contentView.centerYAnchor,
                      padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
  }
  
}
