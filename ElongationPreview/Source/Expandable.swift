//
//  Expandable.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 12/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


protocol Expandable {
  var contentView: UIView { get }
  var topView: UIView! { get set }
  var scalableView: UIView! { get set }
  var bottomView: UIView! { get set }
  
  var bottomViewTopConstraint: NSLayoutConstraint! { get set }
}
