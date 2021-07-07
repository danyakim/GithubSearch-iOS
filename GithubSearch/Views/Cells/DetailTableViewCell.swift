//
//  DetailTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import UIKit

// MARK: - Cell data
struct DetailTableViewCellData {
  let image: UIImage?
  let cellName: String
  let details: String
}

class DetailTableViewCell: UITableViewCell {
  
  // MARK: - UIViews
  private let detailLabel = UILabel()
  
  // MARK: - Initializer
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
  public func configure(with data: DetailTableViewCellData?) {
    guard let data = data else {
      detailLabel.text = nil
      imageView?.image = nil
      textLabel?.text = nil
      return
    }
    detailLabel.text = data.details
    imageView?.image = data.image
    textLabel?.text = data.cellName
  }
  
  // MARK: - Private methods
  private func setupViews() {
    contentView.addSubview(detailLabel)
    detailLabel.anchor(top: contentView.topAnchor,
                       trailing: contentView.trailingAnchor,
                       padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
  }
  
}
