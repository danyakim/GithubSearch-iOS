//
//  AboutTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import UIKit
import Combine

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
  required init(avatarLink: String,
                ownerName: String,
                repoName: String,
                about: String?,
                link: String?,
                stars: Int,
                forks: Int) {
    self.ownerName.text = ownerName
    self.repoName.text = repoName
    self.about.text = about
    self.stars.text = "⭐ " + stars.formatUsingAbbreviation()
    self.forks.text = "⑂ " + forks.formatUsingAbbreviation()
    
    super.init(style: .default, reuseIdentifier: nil)
    
    if let link = link,
       !link.isEmpty {
      self.urlString = link
      self.link.text = "🔗 " + link
      self.link.isUserInteractionEnabled = true
      self.link.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                            action: #selector(openLink)))
    }
    
    loadAvatar(from: avatarLink)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private methods
  private func setupUI() {
    setupLayout()
    configureViews()
  }
  
  @objc private func openLink() {
    guard let urlString = urlString,
          let url = URL(string: urlString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
  
  private func configureViews() {
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
  
}
