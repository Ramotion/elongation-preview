//
//  ElongationDetailViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 11/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit



open class ElongationDetailViewController: UITableViewController {
  
  var isExpanded = true
  
  open var headerView: ElongationHeader!
 
  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
    headerView.addGestureRecognizer(tapGesture)
  }
  
  func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - TableView 📚
extension ElongationDetailViewController {
  
  open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerView?.intrinsicContentSize.height ?? 0
  }
  
  open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }
  
}
