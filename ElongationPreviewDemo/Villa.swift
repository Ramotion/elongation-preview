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
      Villa(country: "France", locality: "Les Houches", description: "A special charm is given by the dark rectangular box above the main entrance.", title: "\(Lorem.name)'s Villa", imageName: "4"),
      Villa(country: "Austria", locality: "Vienna", description: "A wooden table and a beige stuffed couch in front of plasma, this is definitely a good place to spend your afternoons watching movies with your family.", title: "\(Lorem.name)'s Villa", imageName: "7"),
      Villa(country: "Australia", locality: "Sydney", description: "The team working on this project then became larger, also including collaborators Rios Clementi Hale Studios and designers Lorraine Letendre and Lynda Murray.", title: "\(Lorem.name)'s Villa", imageName: "8"),
      Villa(country: "Canada", locality: "Vancouver", description: "You can admire the beautiful landscape through large windows. This  area of the house stands out through the warmth color of the furniture.", title: "\(Lorem.name)'s Villa", imageName: "6"),
      Villa(country: "United States", locality: "Los Angeles", description: "The process of designing and then building a house usually start with a series of requests, a list of requirements coming from the client.", title: "Michael Bay's LA Villa", imageName: "2"),
      Villa(country: "Spain", locality: "Madrid", description: "With a bold façade and large outdoor spaces, this amazing house boasts personality and elegance.", title: "\(Lorem.name)'s Villa", imageName: "3"),
      Villa(country: "Japan", locality: "Tokyo", description: "The second floor incorporates an open living room, kitchen and dining room.", title: "\(Lorem.name)'s Villa", imageName: "5"),
      Villa(country: "Turkey", locality: "Didim", description: "The concept for the villa was originally created by Chad Oppenheim, the founder of the Oppenheim architecture firm.", title: "\(Lorem.name)'s Villa", imageName: "9")
    ]
  }
}
