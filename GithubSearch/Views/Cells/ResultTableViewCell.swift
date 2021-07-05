//
//  ResultTableViewCell.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
  
  // MARK: - UIViews
  private let nameLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let starsLabel = UILabel()
  private let languageLabel = UILabel()
  private let lastUpdatedLabel = UILabel()
  
  // MARK: - Initializers
  required init(name: String?,
                about: String?,
                stars: Int?,
                language: String?,
                lastUpdated: String?) {
    self.nameLabel.text = name
    self.descriptionLabel.text = about
    self.starsLabel.text = "☆ " + (stars ?? 0).formatUsingAbbreviation()
    self.languageLabel.text = language
    
    super.init(style: .default, reuseIdentifier: nil)
    
    self.lastUpdatedLabel.text = "Updated " + getDateDescription(fromString: lastUpdated)
    
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: - Private methods
  private func setupCell() {
    setupLabels()
    let hStack = UIStackView(arrangedSubviews: [starsLabel, languageLabel, lastUpdatedLabel])
    hStack.configure(axis: .horizontal, spacing: 15, alignment: .leading)
    
    let vStack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, hStack])
    vStack.configure(axis: .vertical, spacing: 5, alignment: .leading)
    
    contentView.addSubview(vStack)
    vStack.anchor(top: contentView.topAnchor,
                  leading: contentView.leadingAnchor,
                  bottom: contentView.bottomAnchor,
                  trailing: contentView.trailingAnchor,
                  padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
  }
  
  private func setupLabels() {
    nameLabel.textColor = .blue
    nameLabel.font = .boldSystemFont(ofSize: 18)
    
    descriptionLabel.font = .systemFont(ofSize: 16)
    
    starsLabel.textColor = .darkGray
    starsLabel.font = .systemFont(ofSize: 14)
    
    languageLabel.textColor = .darkGray
    languageLabel.font = .systemFont(ofSize: 14)
    
    lastUpdatedLabel.textColor = .darkGray
    lastUpdatedLabel.font = .systemFont(ofSize: 14)
  }
  
  private func getDateDescription(fromString string: String?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    guard let string = string,
          let lastDate = dateFormatter.date(from: string) else {
      return ""
    }
    let relativeFormatter = RelativeDateTimeFormatter()
    relativeFormatter.unitsStyle = .full
    return relativeFormatter.localizedString(for: lastDate, relativeTo: Date())
  }
  
}
