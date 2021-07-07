//
//  UITableViewExt.swift
//  GithubSearch
//
//  Created by Daniil Kim on 06.07.2021.
//

import Foundation
import UIKit

extension UITableView {
  
  public func register<T: UITableViewCell>(cellClass: T.Type) {
    register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
  }
  
  public func dequeue<T: UITableViewCell>(cellClass: T.Type,
                                          for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier,
                                         for: indexPath) as? T else {
      fatalError("Unable to dequeue cell with identifier: \(cellClass.reuseIdentifier)")
    }
    return cell
  }
  
}
