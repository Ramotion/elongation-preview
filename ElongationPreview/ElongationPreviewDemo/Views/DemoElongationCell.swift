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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Prevent `labelsView` from scaling
    UIView.animate(withDuration: 0.3) {
      if self.isExpanded {
        let frontViewIdentity = self.frontView.transform.inverted()
        self.labelsView.transform = frontViewIdentity
      } else {
        self.labelsView.transform = self.frontView.transform
      }
    }
  }
  
}
