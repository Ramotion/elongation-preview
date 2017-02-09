//
//  ElongationCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class ElongationCell: UITableViewCell {
  
  @IBOutlet public var frontView: UIView!
  @IBOutlet public var frontViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet public var backView: UIView!
  @IBOutlet public var backViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet public var backViewTopConstraint: NSLayoutConstraint!
  
  var dimmingView = UIView()
  
  open var isExpanded = false
  
  fileprivate var appearance: ElongationAppearance {
    return ElongationAppearance.defaultAppearance
  }
    
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
    contentView.backgroundColor = UIColor.white
    
    contentView.addSubview(dimmingView)
    dimmingView.alpha = 0
    dimmingView.backgroundColor = UIColor.black
    dimmingView.frame = bounds
    dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  open func expand(_ value: Bool) {
    isExpanded = value
    UIView.animate(withDuration: 0.3) {
      let backColor: UIColor = value ? .black : .white
      self.backgroundColor = backColor
      self.contentView.backgroundColor = backColor
      
      let frontViewHeight = self.appearance.frontViewHeight
      self.frontViewHeightConstraint.constant = self.appearance.frontViewHeight
      self.backViewTopConstraint.constant = value ? frontViewHeight - self.appearance.backViewOffset : self.appearance.backViewOffset
      self.backViewHeightConstraint.constant = value ? self.appearance.backViewHeight : frontViewHeight - self.appearance.backViewOffset
            
      let frontViewScale = value ? self.appearance.frontViewScaleFactor : 1
      self.frontView.transform = CGAffineTransform(scaleX: frontViewScale, y: frontViewScale)
      
      self.setNeedsLayout()
      self.contentView.layoutIfNeeded()
    }
  }
  
  open override func updateConstraints() {
    frontViewHeightConstraint?.constant = appearance.frontViewHeight
    super.updateConstraints()
  }
  
  open func dim(_ value: Bool, animated: Bool = true) {
    let alpha: CGFloat = value ? 0.9 : 0
    UIView.animate(withDuration: 0.2) {
      self.dimmingView.alpha = alpha
      self.contentView.backgroundColor = value ? .black : .white
      print(self.appearance.frontViewHeight)
    }
  }
  
}
