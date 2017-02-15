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
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
    headerView.addGestureRecognizer(tapGesture)
  }
  
  
  
}

// MARK: - Actions ⚡
extension ElongationDetailViewController {
  
  func headerViewTapped(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: headerView)
    let point = headerView.convert(location, from: view)
    let action = ElongationConfig.shared.headerTouchAction
    guard let touchedView = headerView.hitTest(point, with: nil) else {
      return
    }
    
    switch action {
    case .collpaseOnBoth: dismissViewController()
    case .collapseOnTop:
      if touchedView == headerView.scalableView {
        dismissViewController()
      }
    case .collapseOnBottom:
      if touchedView == headerView.bottomView {
        dismissViewController()
      }
    default: break
    }
    
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
