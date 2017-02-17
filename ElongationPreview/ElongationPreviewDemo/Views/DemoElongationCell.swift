//
//  DemoElongationCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 09/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview


class DemoElongationCell: ElongationCell {
  
  @IBOutlet var labelsView: UIView!
  
  @IBOutlet var topImageView: UIImageView!
  @IBOutlet var localityLabel: UILabel!
  @IBOutlet var countryLabel: UILabel!
  
  @IBOutlet var aboutTitleLabel: UILabel!
  @IBOutlet var aboutDescriptionLabel: UILabel!
  
  @IBOutlet var topImageViewTopConstraint: NSLayoutConstraint!
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    let config = ElongationConfig.shared
    topImageView?.contentMode = config.parallaxEnabled ? .center : .scaleAspectFill
  }
    
}
