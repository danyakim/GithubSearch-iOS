//
//  DetailsVC.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import UIKit

class DetailsVC: UITableViewController {
  
  // MARK: - Properties
  weak var coordinator: RepositoriesCoordinator?
  var resultItem: Repository
  
  // MARK: - Initializers
  init(resultItem: Repository) {
    self.resultItem = resultItem
    
    super.init(style: .plain)
    
    title = resultItem.name
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // remove extra lines after last cell
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
    return UITableView.automaticDimension
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let detailCell = DetailTableViewCell()
    var data: DetailTableViewCellData
    switch indexPath.row {
    case 0:
      let cell = AboutTableViewCell()
      cell.configure(with: AboutTableViewCellData(avatarLink: resultItem.owner.avatarURL,
                                                  ownerName: resultItem.owner.login,
                                                  repoName: resultItem.fullName,
                                                  about: resultItem.itemDescription,
                                                  link: resultItem.homepage,
                                                  stars: resultItem.stargazersCount,
                                                  forks: resultItem.forksCount))
      return cell
    case 1:
      data = DetailTableViewCellData(image: UIImage(systemName: "smallcircle.fill.circle"),
                                         cellName: "Issues",
                                         details: String(resultItem.openIssuesCount))
      
    case 2:
      data = DetailTableViewCellData(image: UIImage(systemName: "eye"),
                                         cellName: "Watchers",
                                         details: String(resultItem.watchersCount))
    case 3:
      data = DetailTableViewCellData(image: UIImage(systemName: "book"),
                                         cellName: "Licence",
                                         details: String(resultItem.license?.name ?? "No License"))
    default:
      fatalError("unknown number of rows in static tableView")
    }
    detailCell.configure(with: data)
    return detailCell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
}
