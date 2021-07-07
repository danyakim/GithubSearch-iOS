//
//  AboutTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import UIKit
import Combine

// MARK: - Cell Data
struct AboutTableViewCellData {
  let avatarLink: String
  let ownerName: String
  let repoName: String
  let about: String?
  let link: String?
  let stars: Int
  let forks: Int
}

class AboutTableViewCell: UITableViewCell {
  
  // MARK: - UIViews
  private let avatar = UIImageView()
  private let ownerName = UILabel()
  private let repoName = UILabel()
  private let about = UILabel()
  private let link = UILabel()
  private let stars = UILabel()
  private let forks = UILabel()
  
  // MARK: - Properties
  private let imageLoader = ImageLoader()
  private var loader: AnyCancellable?
  private var urlString: String?
  
  // MARK: - Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func prepareForReuse() {
    configure(with: nil)
  }
  
  // MARK: - Public methods
  public func configure(with data: AboutTableViewCellData?) {
    guard let data = data else {
      ownerName.text = nil
      repoName.text = nil
      about.text = nil
      stars.text = nil
      forks.text = nil
      link.text = nil
      return
    }
    
    ownerName.text = data.ownerName
    repoName.text = data.repoName
    about.text = data.about
    stars.text = "⭐ " + data.stars.formatUsingAbbreviation()
    forks.text = "⑂ " + data.forks.formatUsingAbbreviation()
    configureLink(url: data.link)
    loadAvatar(from: data.avatarLink)
  }
  
  // MARK: - Private methods
  private func setupUI() {
    setupLayout()
    setupViews()
  }
  
  private func setupLayout() {
    let ownerStack = UIStackView(arrangedSubviews: [avatar, ownerName])
    ownerStack.configure(axis: .horizontal, spacing: 10, alignment: .top)
    
    let numbersStack = UIStackView(arrangedSubviews: [stars, forks])
    numbersStack.configure(axis: .horizontal, spacing: 15, alignment: .top)
    
    let detailsStack = UIStackView(arrangedSubviews: [link, numbersStack])
    detailsStack.configure(axis: .vertical, spacing: 15, alignment: .leading)
    
    let aboutStack = UIStackView(arrangedSubviews: [repoName, about])
    aboutStack.configure(axis: .vertical, spacing: 10, alignment: .leading)
    
    let mainStack = UIStackView(arrangedSubviews: [ownerStack, aboutStack, detailsStack])
    mainStack.configure(axis: .vertical, spacing: 15, alignment: .leading)
    mainStack.distribution = .equalSpacing
    
    contentView.addSubview(mainStack)
    mainStack.anchor(top: contentView.topAnchor,
                     leading: contentView.leadingAnchor,
                     bottom: contentView.bottomAnchor,
                     trailing: contentView.trailingAnchor,
                     padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
  }
  
  private func setupViews() {
    avatar.anchor(size: CGSize(width: 20, height: 20))
    
    ownerName.font = .systemFont(ofSize: 16)
    ownerName.textColor = .gray
    
    repoName.font = .boldSystemFont(ofSize: 22)
    
    about.numberOfLines = 3
    about.sizeToFit()
    
    link.font = .boldSystemFont(ofSize: 14)
    link.textColor = .blue
    
    stars.font = .systemFont(ofSize: 14)
    forks.font = .systemFont(ofSize: 14)
  }
  
  private func loadAvatar(from link: String) {
    loader = imageLoader.load(from: link)
      .sink { [weak self] image in
        self?.avatar.image = image
      }
  }
  
  private func configureLink(url: String?) {
    if let url = url,
       !url.isEmpty {
      urlString = url
      link.text = "🔗 " + url
      link.isUserInteractionEnabled = true
      link.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(openLink)))
    }
  }
  
  @objc private func openLink() {
    guard let urlString = urlString,
          let url = URL(string: urlString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
}
