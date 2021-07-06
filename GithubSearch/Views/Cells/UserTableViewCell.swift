//
//  UserTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import UIKit
import Combine

// MARK: - Cell Data
struct UserTableViewCellData {
  let name: String
  let avatarURL: String
}

class UserTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  let defaultImage = UIImage(systemName: "person.fill")
  
  private let imageLoader = ImageLoader()
  private var loader: AnyCancellable?
  
  // MARK: - Initializers
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func prepareForReuse() {
    configure(with: nil)
  }
  
  // MARK: - Public methods
  public func configure(with data: UserTableViewCellData?) {
    guard let data = data else {
      textLabel?.text = nil
      imageView?.image = defaultImage
      return
    }
    loader?.cancel()
    loadImage(from: data.avatarURL)
    textLabel?.text = data.name
  }
  
  // MARK: - Private methods
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
    
    imageView?.image = defaultImage
  }
  
  private func loadImage(from link: String) {
    loader = imageLoader.load(from: link)
      .sink { [weak self] image in
        self?.imageView?.image = image
      }
  }
}
