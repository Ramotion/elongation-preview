//
//  UIEdgeInsets.swift
//  sahihBukhari
//
//  Created by Abdurahim Jauzee on 06/08/16.
//  Copyright © 2016 Jawziyya. All rights reserved.
//

import UIKit


/// :nodoc:
public extension UIEdgeInsets {

  /// Initialize UIEdgeInsets with given value for all the sides.
  /// UIEdgeInsets(15) == UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
  public init(_ padding: CGFloat) {
    top = CGFloat(padding)
    bottom = CGFloat(padding)
    left = CGFloat(padding)
    right = CGFloat(padding)
  }
  
  /// Initialize UIEdgeInsets with given values for top & bottom, left & right sides.
  /// UIEdgeInsets(padding: 15, sidePadding: 16) == UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
  public init(padding: CGFloat, sidePadding: CGFloat = 0) {
    top = padding; bottom = padding
    left = sidePadding; right = sidePadding
  }
  
  /// Initialize UIEdgeInsets with inset on desired side.
  /// UIEdgeInsets(top: 20) == UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  /// UIEdgeInsets(top: 20, otherSides: 15) == UIEdgeInsets(top: 20, left: 15, bottom: 15, right: 15)
  public init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, otherSides: CGFloat? = nil) {
    self.top = top ?? otherSides ?? 0
    self.left = left ?? otherSides ?? 0
    self.bottom = bottom ?? otherSides ?? 0
    self.right = right ?? otherSides ?? 0
  }
  
}
