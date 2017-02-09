//
//  ViewController.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview


class ViewController: ElongationViewController {
  
  var datasource: [Villa] = Array(1...7).map { i in
    return Villa(country: Lorem.name, locality: Lorem.firstName, description: Lorem.sentences(1), owner: Lorem.name, imageName: "\(i)")
  }
  
}

// MARK: - Lifecycle 🌎
extension ViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print(ElongationAppearance.defaultAppearance.frontViewHeight)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}

// MARK: - Setup ⛏
private extension ViewController {
  
  func setup() {
    tableView.registerNib(DemoElongationCell.self)
  }
  
}

// MARK: - TableView 📚
extension ViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(DemoElongationCell.self)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? DemoElongationCell else { return }
    
    let villa = datasource[indexPath.row]
    
    let attributedLocality = NSMutableAttributedString(string: villa.locality.uppercased(), attributes: [
      NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30),
      NSKernAttributeName: 5,
      NSForegroundColorAttributeName: UIColor.white
      ])
    
    cell.topImageView.image = UIImage(named: villa.imageName)
    cell.localityLabel.attributedText = attributedLocality
    cell.countryLabel.text = villa.country
    cell.aboutTitleLabel.text = villa.owner
    cell.aboutDescriptionLabel.text = villa.description
  }
  
}
