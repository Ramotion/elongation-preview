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
  
  /// Empty public initializer.
  public init() { }
  
  /// Shared instance. Override this property to apply changes.
  public static var shared = ElongationConfig()
  
  // MARK: Behaviour 🔧
  public enum ExpandingBehaviour {
    /// Scroll tableView's content to center.
    case centerInView
    /// Scroll tableView's content to top.
    case scrollToTop
    /// Scroll tableView's content to bottom.
    case scrollToBottom
    case doNothing
  }
  
  public var expandingBehaviour: ExpandingBehaviour = .centerInView
  
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
  
  /// Enable gestures on `ElongationCell` & `ElongationHeader`.
  /// These gestures will give ability to expand/dismiss the cell and detail view controller.
  /// Default value: `true`
  public var isSwipeGesturesEnabled = true
  
  
  // MARK: Appearance 🎨

  /// Actual height of `topView`. 
  /// Default value: `200`
  public var topViewHeight: CGFloat = 200
  
  /// `topView` scale value which will be used for making CGAffineTransform
  /// to `expanded` state
  /// Default value: `0.9`
  public var scaleViewScaleFactor: CGFloat = 0.9
  
  /// Parallax effect factor.
  /// Default value: `nil`
  public var parallaxFactor: CGFloat?
  
  /// Should we enable parallax effect on ElongationCell (read-only).
  /// Will be `true` if `separator` not `nil` && greater than zero
  public var isParallaxEnabled: Bool {
    switch parallaxFactor {
    case .none: return false
    case .some(let value): return value > 0
    }
  }
  
  /// Offset of `bottomView` against `topView`
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
  
  /// Should we create custom separator view (read-only).
  /// Will be `true` if `separator` not `nil` && greater than zero.
  public var customSeparatorEnabled: Bool {
    switch separatorHeight {
    case .none: return false
    case .some(let value): return value > 0
    }
  }
  
  /// Duration of `detail` view controller presention animation
  /// Default value: `0.3`
  public var detailPresetingDuration: TimeInterval = 0.3
  
  /// Duration of `detail` view controller dismissing animation
  /// Default value: `0.4`
  public var detailDismissingDuration: TimeInterval = 0.4
  
}
