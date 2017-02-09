//
//  Villa.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 09/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation


struct Villa {
  
  let country: String
  let locality: String
  let description: String
  let owner: String
  let imageName: String
  
  init(country: String, locality: String, description: String, owner: String, imageName: String) {
    self.country = country
    self.locality = locality
    self.description = description
    self.owner = owner
    self.imageName = imageName
  }
  
}
