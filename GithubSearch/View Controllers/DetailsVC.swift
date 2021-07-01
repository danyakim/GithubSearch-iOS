//
//  DetailsVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit

class DetailsVC: UITableViewController {
  
  // MARK: - Properties
  weak var coordinator: MainCoordinator?
  var resultItem: ResultItem
  
  // MARK: - Initializers
  init(resultItem: ResultItem) {
    self.resultItem = resultItem
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ///remove extra lines after last cell
    tableView.tableFooterView = UIView()
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.row == 0 ? 220 : 44
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let aboutCell = AboutTableViewCell(avatarLink: resultItem.owner.avatarURL,
                                         ownerName: resultItem.owner.login,
                                         repoName: resultItem.fullName,
                                         about: resultItem.itemDescription,
                                         link: resultItem.homepage,
                                         stars: resultItem.stargazersCount,
                                         forks: resultItem.forksCount)
      return aboutCell
    }
    switch indexPath.row {
    case 1:
      return DetailTableViewCell(image: UIImage(systemName: "smallcircle.fill.circle"),
                                 cellName: "Issues",
                                 details: String(resultItem.openIssuesCount))
    case 2:
      return DetailTableViewCell(image: UIImage(systemName: "eye"),
                                 cellName: "Watchers",
                                 details: String(resultItem.watchersCount))
    case 3:
      return DetailTableViewCell(image: UIImage(systemName: "smallcircle.fill.circle"),
                                 cellName: "Issues",
                                 details: String(resultItem.openIssuesCount))
    default:
      fatalError("unknown number of rows in static tableView")
    }
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
}
