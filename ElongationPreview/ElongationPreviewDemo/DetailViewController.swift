//
//  DetailViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 14/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview


class DetailViewController: ElongationDetailViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor.white
    tableView.register(UITableViewCell.self)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 15
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(UITableViewCell.self)
    cell.textLabel?.text = "Row #\(indexPath.row)"
    return cell
  }
  
}
