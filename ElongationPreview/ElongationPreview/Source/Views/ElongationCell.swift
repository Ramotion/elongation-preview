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
  @IBOutlet public var topViewTopConstraint: NSLayoutConstraint!
  
  /// This is the top view which can be scaled if `scaleFactor` was configured in `ElongationAppearance`.
  /// Also to this view can be applied 'parallax' effect.
  @IBOutlet public var scalableView: UIView!
  
  @IBOutlet public var parallaxViewCenterConstraint: NSLayoutConstraint!
  @IBOutlet public var parallaxViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet public var bottomView: UIView!
  @IBOutlet public var bottomViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet public var bottomViewTopConstraint: NSLayoutConstraint!
  
  
  // MARK: Internal properties
  var topSeparatorLine: UIView?
  var bottomSeparatorLine: UIView?
  
  // MARK: Private properties
  fileprivate var dimmingView: UIView!
  fileprivate var appearance: ElongationConfig {
    return ElongationConfig.shared
  }
  
  fileprivate var scalableViewTopOffset: CGFloat!
  fileprivate var scalableViewBottomOffset: CGFloat!
  
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
    setupConstraintsIfNeeded()
    setupCustomSeparatorIfNeeded()
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    if #available(iOS 10, *) {
      UIView.animate(withDuration: 0.3) { self.contentView.layoutIfNeeded() }
    }
  }
  
}

// MARK: - Setup ⛏
extension ElongationCell {
  
  public func configureCell() {
    selectionStyle = .none
    selectedBackgroundView = nil
    clipsToBounds = true
    contentView.clipsToBounds = true
  }
  
  fileprivate func addDimmingView() {
    dimmingView = UIView()
    contentView.addSubview(dimmingView)
    dimmingView.alpha = 0
    dimmingView.backgroundColor = UIColor.black
    dimmingView.frame = bounds
    dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  fileprivate func setupCustomSeparatorIfNeeded() {
    guard appearance.customSeparatorEnabled, let separatorHeight = appearance.separatorHeight else { return }
    let topSeparator = UIView()
    let bottomSeparator = UIView()
    
    let separators = [topSeparator, bottomSeparator]
    
    for separator in separators {
      contentView.insertSubview(separator, belowSubview: dimmingView)
      separator.backgroundColor = appearance.separatorColor
      separator.translatesAutoresizingMaskIntoConstraints = false
      
      let topOrBottomAttribute: NSLayoutAttribute = separator === topSeparator ? .top : .bottom
      
      contentView.addConstraints([
        NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: separator, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: separator, attribute: topOrBottomAttribute, relatedBy: .equal, toItem: contentView, attribute: topOrBottomAttribute, multiplier: 1, constant: 0)
        ])
      
      separator.addConstraint(NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: separatorHeight))
    }
    
    topSeparatorLine = topSeparator
    bottomSeparatorLine = bottomSeparator
  }
  
}

// MARK: - Layout 🔬
extension ElongationCell {
  
  func setupConstraintsIfNeeded() {
    let separatorHeight = appearance.separatorHeight ?? 0
    topViewHeightConstraint?.constant = appearance.topViewHeight - (separatorHeight * 2)
    topViewTopConstraint?.constant = separatorHeight
    if appearance.isParallaxEnabled, let parallaxFactor = appearance.parallaxFactor {
      parallaxViewHeightConstraint?.constant = appearance.topViewHeight + parallaxFactor
    }
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
        
        self.hideSeparator(value, animated: false)
      }, completion: nil)
    } else {
      updateCellState()
      hideSeparator(value, animated: false)
    }
  }
  
  open func dim(_ value: Bool, animated: Bool = true) {
    let alpha: CGFloat = value ? 0.9 : 0
    if animated {
      UIView.animate(withDuration: 0.2) {
        self.dimmingView.alpha = alpha
        self.contentView.backgroundColor = value ? .black : .clear
      }
    } else {
      self.dimmingView.alpha = alpha
      self.contentView.backgroundColor = value ? .black : .clear
    }
  }
  
  // MARK: Private
  fileprivate func updateCellState() {
    let backColor: UIColor = isExpanded ? .black : .clear
    backgroundColor = backColor
    contentView.backgroundColor = backColor
    
    if let separatorHeight = appearance.separatorHeight {
      topViewHeightConstraint.constant = isExpanded ? appearance.topViewHeight : appearance.topViewHeight - separatorHeight * 2
      topViewTopConstraint.constant = isExpanded ? 0 : separatorHeight
    }
    
    let frontViewHeight = self.appearance.topViewHeight
    bottomViewTopConstraint.constant = isExpanded ? frontViewHeight - appearance.bottomViewOffset : appearance.bottomViewOffset
    bottomViewHeightConstraint.constant = isExpanded ? appearance.bottomViewHeight : frontViewHeight - appearance.bottomViewOffset
    
    let frontViewScale = appearance.scaleViewScaleFactor
    scalableView.transform = isExpanded ? CGAffineTransform(scaleX: frontViewScale, y: frontViewScale) : .identity
    
    contentView.setNeedsLayout()
    contentView.layoutIfNeeded()
  }

  func hideSeparator(_ value: Bool, animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.15) {
        self.topSeparatorLine?.alpha = value ? 0 : 1
        self.bottomSeparatorLine?.alpha = value ? 0 : 1
      }
    } else {
      self.topSeparatorLine?.alpha = value ? 0 : 1
      self.bottomSeparatorLine?.alpha = value ? 0 : 1
    }
  }
  
  func parallaxOffset(offsetY: CGFloat, height: CGFloat) {
    guard let centerConstraint = parallaxViewCenterConstraint, let parallaxFactor = appearance.parallaxFactor else {
      return
    }
    
    var deltaY = (frame.origin.y + frame.height / 2) - offsetY
    deltaY = min(height, max(deltaY, 0))
    
    var move = deltaY / height * parallaxFactor
    move = move / 2.0 - move
    
    centerConstraint.constant = move
  }
  
}

// MARK: - Endode/Decode
extension ElongationCell {
  
  fileprivate struct Keys {
    static let isExpanded = "isExpanded"
    static let dimmingView = "dimmingView"
    
    static let scalableView = "scalableView"
    
    static let topView = "topView"
    static let topViewHeightConstraint = "topViewHeightConstraint"
    static let topViewTopConstraint = "topViewTopConstraint"
    
    static let bottomView = "backView"
    static let bottomViewHeightConstraint = "bottomViewHeightConstraint"
    static let bottomViewTopConstraint = "bottomViewTopConstraint"
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
    aCoder.encode(topViewHeightConstraint, forKey: Keys.topViewHeightConstraint)
    aCoder.encode(topViewTopConstraint, forKey: Keys.topViewTopConstraint)
    
    aCoder.encode(bottomView, forKey: Keys.bottomView)
    aCoder.encode(bottomViewTopConstraint, forKey: Keys.bottomViewTopConstraint)
    aCoder.encode(bottomViewHeightConstraint, forKey: Keys.bottomViewHeightConstraint)
    
    aCoder.encode(scalableView, forKey: Keys.scalableView)
  }

  fileprivate func decode(from coder: NSCoder) {
    
    if let isExpanded = coder.decodeObject(forKey: Keys.isExpanded) as? Bool {
      self.isExpanded = isExpanded
    }
    
    if let topView = coder.decodeObject(forKey: Keys.topView) as? UIView {
      self.topView = topView
    }
    
    if let topViewHeightConstraint = coder.decodeObject(forKey: Keys.topViewHeightConstraint) as? NSLayoutConstraint {
      self.topViewHeightConstraint = topViewHeightConstraint
    }
    
    if let topViewTopConstraint = coder.decodeObject(forKey: Keys.topViewTopConstraint) as? NSLayoutConstraint {
      self.topViewTopConstraint = topViewTopConstraint
    }
    
    if let bottomView = coder.decodeObject(forKey: Keys.bottomView) as? UIView {
      self.bottomView = bottomView
    }
    
    if let bottomViewTopConstraint = coder.decodeObject(forKey: Keys.bottomViewTopConstraint) as? NSLayoutConstraint {
      self.bottomViewTopConstraint = bottomViewTopConstraint
    }
    
    if let bottomViewHeightConstraint = coder.decodeObject(forKey: Keys.bottomViewHeightConstraint) as? NSLayoutConstraint {
      self.bottomViewHeightConstraint = bottomViewHeightConstraint
    }
    
    if let scalableView = coder.decodeObject(forKey: Keys.scalableView) as? UIView {
      self.scalableView = scalableView
    }
    
  }
  
}
