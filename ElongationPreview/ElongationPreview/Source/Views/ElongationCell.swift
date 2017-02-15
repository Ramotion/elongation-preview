//
//  ElongationCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class ElongationCell: UITableViewCell, Expandable {
  
  // MARK: Public properties
  open var isExpanded = false
  
  @IBOutlet public var topView: UIView!
  @IBOutlet public var topViewHeightConstraint: NSLayoutConstraint!
  
  /// This is the top view which can be scaled if `scaleFactor` was configured in `ElongationAppearance`.
  /// Also to this view can be applied 'parallax' effect.
  @IBOutlet public var scalableView: UIView!
  @IBOutlet public var scalableViewTopConstraint: NSLayoutConstraint!
  @IBOutlet public var scalableViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet public var bottomView: UIView!
  @IBOutlet public var bottomViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet public var bottomViewTopConstraint: NSLayoutConstraint!
  @IBOutlet public var bottomViewBottomConstraint: NSLayoutConstraint!
  
  // MARK: Private properties
  fileprivate var dimmingView: UIView!
  fileprivate var topSeparatorLine: UIView?
  fileprivate var bottomSeparatorLine: UIView?
  fileprivate var appearance: ElongationConfig {
    return ElongationConfig.shared
  }
  
  fileprivate var scalableViewTopOffset: CGFloat!
  fileprivate var scalableViewBottomOffset: CGFloat!
  fileprivate var scalableViewLastParrallaxOffset: CGFloat!
  
  // MARK: Constructor
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    decode(from: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    configureCell()
    addDimmingView()
    addCustomSeparatorIfNeeded()
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

// MARK: - Lifecycle 🌎
extension ElongationCell {
  
  open override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    
    topViewHeightConstraint?.constant = appearance.topViewHeight
    guard appearance.parallaxEnabled else { return }
    scalableViewBottomConstraint?.constant -= 2 * appearance.parallaxFactor
    scalableViewTopOffset = scalableViewTopConstraint?.constant ?? 0
    scalableViewBottomOffset = scalableViewBottomConstraint?.constant ?? 0
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    if #available(iOS 10, *) {
      UIView.animate(withDuration: 0.3) { self.contentView.layoutIfNeeded() }
    }
  }
  
  open override func updateConstraints() {
    
    super.updateConstraints()
  }
  
}

// MARK: - Setup ⛏
private extension ElongationCell {
  
  func configureCell() {
    selectionStyle = .none
    selectedBackgroundView = nil
    clipsToBounds = true
    contentView.clipsToBounds = true
  }
  
  func addDimmingView() {
    dimmingView = UIView()
    contentView.addSubview(dimmingView)
    dimmingView.alpha = 0
    dimmingView.backgroundColor = UIColor.black
    dimmingView.frame = bounds
    dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  func addCustomSeparatorIfNeeded() {
    guard appearance.customSeparatorEnabled else { return }
    let color = appearance.separatorColor
    let topSeparator = UIView()
    topSeparator.backgroundColor = color
  }
  
}

// MARK: - Actions ⚡
extension ElongationCell {
  
  // MARK: Public
  open func expand(_ value: Bool, animated: Bool = true) {
    isExpanded = value
    
    if animated {
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
        self.updateCellState()
      }, completion: nil)
    } else {
      updateCellState()
    }
  }
  
  open func dim(_ value: Bool, animated: Bool = true) {
    let alpha: CGFloat = value ? 0.9 : 0
    if animated {
      UIView.animate(withDuration: 0.2) {
        self.dimmingView.alpha = alpha
        self.contentView.backgroundColor = value ? .black : .white
      }
    } else {
      self.dimmingView.alpha = alpha
      self.contentView.backgroundColor = value ? .black : .white
    }
  }
  
  // MARK: Private
  fileprivate func updateCellState() {
    let backColor: UIColor = isExpanded ? .black : .white
    backgroundColor = backColor
    contentView.backgroundColor = backColor
    
    if appearance.parallaxEnabled {
      let value = scalableViewLastParrallaxOffset ?? 0
      scalableViewTopConstraint.constant = isExpanded ? 0 : -value
      scalableViewBottomConstraint.constant = isExpanded ? 0 : value
      print(value)
    }
    
    let frontViewHeight = self.appearance.topViewHeight
    bottomViewTopConstraint.constant = isExpanded ? frontViewHeight - appearance.bottomViewOffset : appearance.bottomViewOffset
    bottomViewHeightConstraint.constant = isExpanded ? appearance.bottomViewHeight : frontViewHeight - appearance.bottomViewOffset
    
    let frontViewScale = appearance.scaleViewScaleFactor
    scalableView.transform = isExpanded ? CGAffineTransform(scaleX: frontViewScale, y: frontViewScale) : .identity
    
    contentView.setNeedsLayout()
    contentView.layoutIfNeeded()
  }
  
  func setFrontViewOffset(_ offset: CGFloat) {
    guard appearance.parallaxEnabled, let topConstraint = scalableViewTopConstraint, let bottomConstraint = scalableViewBottomConstraint else { return }
    let boundOffset = max(0, min(1, offset))
    let pixelOffset = (1 - boundOffset) * 2 * appearance.parallaxFactor
    
    topConstraint.constant = scalableViewTopOffset - pixelOffset
    bottomConstraint.constant = scalableViewBottomOffset + pixelOffset
    scalableViewLastParrallaxOffset = pixelOffset
  }
  
}

// MARK: - Endode/Decode
extension ElongationCell {
  
  private struct Keys {
    static let isExpanded = "isExpanded"
    static let frontViewHeightConstraint = "frontViewHeightConstraint"
    static let dimmingView = "dimmingView"
    
    static let scalableView = "scalableView"
    
    static let topView = "topView"
    static let topViewHeightConstraint = "topViewHeightConstraint"
    
    static let bottomView = "backView"
    static let bottomViewHeightConstraint = "bottomViewHeightConstraint"
    static let bottomViewTopConstraint = "bottomViewTopConstraint"
    static let bottomViewBottomConstraint = "bottomViewBottomConstraint"
  }
  
  var cellCopy: ElongationCell? {
    let data = NSKeyedArchiver.archivedData(withRootObject: self)
    guard case let copy as ElongationCell = NSKeyedUnarchiver.unarchiveObject(with: data) else {
      return nil
    }
    return copy
  }
  
  open override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(isExpanded, forKey: Keys.isExpanded)
    aCoder.encode(topView, forKey: Keys.topView)
    aCoder.encode(scalableView, forKey: Keys.scalableView)
    aCoder.encode(topViewHeightConstraint, forKey: Keys.topViewHeightConstraint)
    aCoder.encode(bottomView, forKey: Keys.bottomView)
    aCoder.encode(bottomViewTopConstraint, forKey: Keys.bottomViewTopConstraint)
    aCoder.encode(bottomViewHeightConstraint, forKey: Keys.bottomViewHeightConstraint)
    aCoder.encode(bottomViewBottomConstraint, forKey: Keys.bottomViewBottomConstraint)
  }
  
  fileprivate func decode(from coder: NSCoder) {
    
    if let isExpanded = coder.decodeObject(forKey: Keys.isExpanded) as? Bool {
      self.isExpanded = isExpanded
    }
    
    if let topView = coder.decodeObject(forKey: Keys.topView) as? UIView {
      self.topView = topView
    }
    
    if let scalableView = coder.decodeObject(forKey: Keys.scalableView) as? UIView {
      self.scalableView = scalableView
    }
    
    if let topViewHeightConstraint = coder.decodeObject(forKey: Keys.topViewHeightConstraint) as? NSLayoutConstraint {
      self.topViewHeightConstraint = topViewHeightConstraint
    }
    
    if let backView = coder.decodeObject(forKey: Keys.bottomView) as? UIView {
      self.bottomView = backView
    }
    
    if let bottomViewTopConstraint = coder.decodeObject(forKey: Keys.bottomViewTopConstraint) as? NSLayoutConstraint {
      self.bottomViewTopConstraint = bottomViewTopConstraint
    }
    
    if let bottomViewHeightConstraint = coder.decodeObject(forKey: Keys.bottomViewHeightConstraint) as? NSLayoutConstraint {
      self.bottomViewHeightConstraint = bottomViewHeightConstraint
    }
    
    if let bottomViewBottomConstraint = coder.decodeObject(forKey: Keys.bottomViewBottomConstraint) as? NSLayoutConstraint {
      self.bottomViewBottomConstraint = bottomViewBottomConstraint
    }
    
  }
  
}
