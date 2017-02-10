//
//  ElongationAppearance.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 09/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


/// ElongationViewController's cells configuration object
public struct ElongationAppearance {
  
  /// Default appearance configuration
  public static var defaultAppearance = ElongationAppearance()
  
  // Empty public initializer needed to have an access out of module
  public init() { }
  
  /// Actual height of `frontView`. Default value: 200
  public var frontViewHeight: CGFloat = 200
  
  /// `frontView` scale value which will be used for making CGAffineTransform
  /// to `expanded` state
  /// Default value: 0.9
  public var frontViewScaleFactor: CGFloat = 0.9
  
  /// Offset of `backView` against `frontView`
  /// Default value: 20
  public var backViewOffset: CGFloat = 20
  
  /// `backView` height value
  /// Default value: 180
  public var backViewHeight: CGFloat = 180
  
}
