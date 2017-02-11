//
//  ElongationCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class ElongationCell: UITableViewCell {
  
  // MARK: Public properties
  open var isExpanded = false
  
  @IBOutlet public var frontView: UIView!
  @IBOutlet public var frontViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet public var backView: UIView!
  @IBOutlet public var backViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet public var backViewTopConstraint: NSLayoutConstraint!
  
  // MARK: Private properties
  fileprivate var dimmingView = UIView()
  
  fileprivate var appearance: ElongationAppearance {
    return ElongationAppearance.defaultAppearance
  }
  
  // MARK: Constructor
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    selectionStyle = .none
    selectedBackgroundView = nil
    clipsToBounds = true
    contentView.clipsToBounds = true
    
    contentView.addSubview(dimmingView)
    dimmingView.alpha = 0
    dimmingView.backgroundColor = UIColor.black
    dimmingView.frame = bounds
    dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let frontViewContainsPoint = frontView.frame.contains(point)
    let backViewContainsPoint = backView.frame.contains(point)
    
    if frontViewContainsPoint {
      return frontView
    }
    
    if backViewContainsPoint {
      return backView
    }
    
    return nil
  }
  
}

// MARK: - Lifecycle 🌎
extension ElongationCell {
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    if #available(iOS 10, *) {
      UIView.animate(withDuration: 0.3) { self.contentView.layoutIfNeeded() }
    }
  }
  
  open override func updateConstraints() {
    frontViewHeightConstraint?.constant = appearance.frontViewHeight
    super.updateConstraints()
  }
  
}

// MARK: - Actions ⚡
extension ElongationCell {
  
  // MARK: Public
  open func expand(_ value: Bool, animated: Bool = true) {
    isExpanded = value
    
    if animated {
      UIView.animate(withDuration: 0.3) {
        self.updateCellState()
      }
    } else {
      updateCellState()
    }
  }
  
  open func dim(_ value: Bool, animated: Bool = true) {
    let alpha: CGFloat = value ? 0.9 : 0
    UIView.animate(withDuration: 0.2) {
      self.dimmingView.alpha = alpha
      self.contentView.backgroundColor = value ? .black : .white
    }
  }
  
  // MARK: Private
  fileprivate func updateCellState() {
    let backColor: UIColor = isExpanded ? .black : .white
    self.backgroundColor = backColor
    self.contentView.backgroundColor = backColor
    
    let frontViewHeight = self.appearance.frontViewHeight
    self.backViewTopConstraint.constant = isExpanded ? frontViewHeight - self.appearance.backViewOffset : self.appearance.backViewOffset
    self.backViewHeightConstraint.constant = isExpanded ? self.appearance.backViewHeight : frontViewHeight - self.appearance.backViewOffset
    
    let frontViewScale = isExpanded ? self.appearance.frontViewScaleFactor : 1
    self.frontView.transform = CGAffineTransform(scaleX: frontViewScale, y: frontViewScale)
    
    self.contentView.setNeedsLayout()
    self.contentView.layoutIfNeeded()
  }
  
}
