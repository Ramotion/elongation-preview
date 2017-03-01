//
//  ElongationHeader.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 14/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


/// Expanded copy of `ElongationCell`.
open class ElongationHeader: UIView, Expandable {
  
  /// Container of all the subviews.
  public var contentView: UIView = UIView()
  
  /// View on top half of `contentView`.
  /// Add here all the views which wont be scaled and must stay on their position.
  public var topView: UIView!
  
  /// This is the front view which can be scaled if `scaleFactor` was configured in `ElongationConfig`.
  /// Also to this view can be applied 'parallax' effect.
  public var scalableView: UIView!
  
  /// The view which comes from behind the cell when you tap on the cell.
  public var bottomView: UIView!
  
  /// `top` constraint of `bottomView`.
  public var bottomViewTopConstraint: NSLayoutConstraint!
  
  fileprivate var appearance: ElongationConfig {
    return ElongationConfig.shared
  }
  
  /// :nodoc:
  override open var intrinsicContentSize: CGSize {
    let height = appearance.topViewHeight + appearance.bottomViewHeight
    let width = UIScreen.main.bounds.width
    return CGSize(width: width, height: height)
  }
  
  /// :nodoc:
  open override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = bounds
  }
  
  /// :nodoc:
  open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let scalableViewContainsPoint = scalableView.frame.contains(point)
    let backViewContainsPoint = bottomView.frame.contains(point)
    
    if scalableViewContainsPoint {
      return scalableView
    }
    
    if backViewContainsPoint {
      return bottomView
    }
    
    return nil
  }
  
}


// MARK: - ElongationCell -> ElongationHeader
extension ElongationCell {
  
  var elongationHeader: ElongationHeader {
    guard let copy = cellCopy else { return ElongationHeader() }
    let elongationHeader = ElongationHeader()
    elongationHeader.contentView = copy.contentView
    elongationHeader.topView = copy.topView
    elongationHeader.scalableView = copy.scalableView
    elongationHeader.bottomView = copy.bottomView
    elongationHeader.bottomViewTopConstraint = copy.bottomViewTopConstraint
    elongationHeader.addSubview(copy.contentView)
    return elongationHeader
  }
  
}
