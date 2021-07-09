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
  
  func setupLoadingIndicator() {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: bounds.width, height: 44)
    tableFooterView = spinner
    tableFooterView?.isHidden = true
  }
  
  func showLoadingIndicator(_ shouldShow: Bool) {
    guard let footer = tableFooterView,
            footer.self is UIActivityIndicatorView else {
      print("tableFooterView is not a Spinner")
      return
    }
    if shouldShow {
      footer.isHidden = false
    } else {
      footer.isHidden = true
    }
  }
  
}
