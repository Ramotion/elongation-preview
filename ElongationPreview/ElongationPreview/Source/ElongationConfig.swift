//
//  ElongationConfig.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 09/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


/// Whole module views configuration
public struct ElongationConfig {
  
  // Empty public initializer needed to have an access out of module
  public init() { }
  
  public static var shared = ElongationConfig()
  
  // MARK: Behaviour 🔧
  
  public enum CellTouchAction {
    case collapseOnTopExpandOnBottom, collapseOnBottomExpandOnTop, collapseOnBoth, expandOnBoth, expandOnTop, expandOnBottom
  }
  
  /// What `elongationCell` should do on touch
  public var cellTouchAction = CellTouchAction.collapseOnTopExpandOnBottom
  
  public enum HeaderTouchAction {
    case collpaseOnBoth, collapseOnTop, collapseOnBottom, noAction
  }
  
  /// What `elongationHeader` should do on touch
  public var headerTouchAction = HeaderTouchAction.collapseOnTop
  
  
  // MARK: Appearance 🎨

  /// Actual height of `frontView`. Default value: 200
  public var topViewHeight: CGFloat = 200
  
  /// `frontView` scale value which will be used for making CGAffineTransform
  /// to `expanded` state
  /// Default value: `0.9`
  public var scaleViewScaleFactor: CGFloat = 0.9
  
  /// Parallax effect factor.
  /// Default value: `50`
  public var parallaxFactor: CGFloat = 50
  
  public var parallaxEnabled: Bool {
    return parallaxFactor > 0
  }
  
  /// Offset of `bottomView` against `frontView`
  /// Default value: `20`
  public var bottomViewOffset: CGFloat = 20
  
  /// `bottomView` height value
  /// Default value: `180`
  public var bottomViewHeight: CGFloat = 180
  
  /// Height of custom separator line between cells in tableView
  /// Default value: `nil`
  public var separatorHeight: CGFloat?
  
  /// Color of custom separator
  /// Default value: `.white`
  public var separatorColor: UIColor = .white
  
  /// Should we create custom separator view
  /// Will be `true` if `separator` not `nil` && greater than zero
  public var customSeparatorEnabled: Bool {
    switch separatorHeight {
    case .none: return false
    case .some(_): return true
    }
  }
  
}
