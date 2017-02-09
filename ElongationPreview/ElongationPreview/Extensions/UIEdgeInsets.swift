//
//  UIEdgeInsets.swift
//  sahihBukhari
//
//  Created by Abdurahim Jauzee on 06/08/16.
//  Copyright © 2016 Jawziyya. All rights reserved.
//

import UIKit


extension UIEdgeInsets {
  
  public init(_ padding: CGFloat) {
    top = CGFloat(padding)
    bottom = CGFloat(padding)
    left = CGFloat(padding)
    right = CGFloat(padding)
  }
  
  public init(padding: CGFloat, sidePadding: CGFloat = 0) {
    top = padding; bottom = padding
    left = sidePadding; right = sidePadding
  }
  
  public init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, otherSides: CGFloat? = nil) {
    self.top = top ?? otherSides ?? 0
    self.left = left ?? otherSides ?? 0
    self.bottom = bottom ?? otherSides ?? 0
    self.right = right ?? otherSides ?? 0
  }
  
}
