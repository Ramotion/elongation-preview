//
//  ElongationHeader.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 14/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class ElongationHeader: UIView, Expandable {
  
  public var isExpanded = true
  public var contentView: UIView = UIView()
  public var topView: UIView!
  public var scalableView: UIView!
  public var bottomView: UIView!
  public var bottomViewTopConstraint: NSLayoutConstraint!
  
  fileprivate var appearance: ElongationConfig {
    return ElongationConfig.shared
  }
  
  override open var intrinsicContentSize: CGSize {
    let height = appearance.topViewHeight + appearance.bottomViewHeight
    let width = UIScreen.main.bounds.width
    return CGSize(width: width, height: height)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = bounds
  }
  
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
