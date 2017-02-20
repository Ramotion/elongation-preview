//
//  UIFont.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 11/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


extension UIFont {
  
  enum FontWeight: String {
    case regular, medium, bold
  }
  
  static func robotoFont(ofSize: CGFloat, weight: FontWeight = .regular) -> UIFont {
    return UIFont(name: "Roboto-\(weight.rawValue.capitalized)", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
  }
  
}
