//
//  UIStackViewExt.swift
//  GithubSearch
//
//  Created by Daniil Kim on 01.07.2021.
//

import Foundation
import UIKit

extension UIStackView {
  
  func configure(axis: NSLayoutConstraint.Axis,
                 spacing: CGFloat,
                 alignment: UIStackView.Alignment) {
    self.axis = axis
    self.spacing = spacing
    self.alignment = alignment
  }
  
}
