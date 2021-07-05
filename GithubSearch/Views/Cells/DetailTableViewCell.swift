//
//  DetailTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
  
  // MARK: - UIViews
  private let detailLabel = UILabel()
  
  // MARK: - Initializer
  required init(image: UIImage?,
                cellName: String,
                details: String) {
    detailLabel.text = details
    
    super.init(style: .default, reuseIdentifier: nil)
    
    imageView?.image = image
    textLabel?.text = cellName
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private methods
  private func setupViews() {
    contentView.addSubview(detailLabel)
    detailLabel.anchor(top: contentView.topAnchor,
                       trailing: contentView.trailingAnchor,
                       padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
  }
  
}
