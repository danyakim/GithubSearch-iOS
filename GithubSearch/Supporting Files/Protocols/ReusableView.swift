//
//  ReusableView.swift
//  GithubSearch
//
//  Created by Daniil Kim on 05.07.2021.
//

import Foundation

protocol ReusableView {
  
  static var reuseIdentifier: String { get }
  
}

extension ReusableView {
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
}
