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
  let title: String
  let imageName: String
  
  init(country: String, locality: String, description: String, title: String, imageName: String) {
    self.country = country
    self.locality = locality
    self.description = description
    self.title = title
    self.imageName = imageName
  }
  
}

extension Villa {
  static var testData: [Villa] {
    return [
      Villa(country: "Swiss", locality: "Swiss Alps", description: "This residential project was recently completed by D4 Designs, a multi-award winning design practice founded in 2000 by Douglas Paton.", title: "\(Lorem.name)'s Villa", imageName: "1"),
      Villa(country: "United States", locality: "Los Angeles", description: "The process of designing and then building a house usually start with a series of requests, a list of requirements coming from the client.", title: "Michael Bay's LA Villa", imageName: "2"),
      Villa(country: "Spain", locality: "Madrid", description: "With a bold façade and large outdoor spaces, this amazing house boasts personality and elegance.", title: "\(Lorem.name)'s Villa", imageName: "3"),
      Villa(country: "France", locality: "Les Houches", description: "A special charm is given by the dark rectangular box above the main entrance.", title: "\(Lorem.name)'s Villa", imageName: "4"),
      Villa(country: "Japan", locality: "Tokyo", description: "The second floor incorporates an open living room, kitchen and dining room.", title: "\(Lorem.name)'s Villa", imageName: "5")
    ]
  }
}
