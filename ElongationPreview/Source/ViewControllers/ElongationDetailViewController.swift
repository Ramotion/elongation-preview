//
//  ElongationDetailViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 11/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


/**
 
 UITableViewController subclass.
 
 This is the `detail` view controller which can be used for display some details for objects from `root`.
 
 */
open class ElongationDetailViewController: SwipableTableViewController {
  
  /// Actually this is `expanded` copy of `ElongationCell`.
  open var headerView: ElongationHeader!
  
  fileprivate var config: ElongationConfig {
    return .shared
  }
  
}

// MARK: - Lifecycle 🌎
extension ElongationDetailViewController {
  
  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
    headerView?.addGestureRecognizer(tapGesture)
  }
  
  override func gestureRecognizerSwiped(_ gesture: UIPanGestureRecognizer) {
    guard config.isSwipeGesturesEnabled else { return }
    let location = gesture.location(in: tableView)
    let point = headerView.convert(location, from: tableView)
    guard headerView.point(inside: location, with: nil), let view = headerView.hitTest(point, with: nil) else { return }
    if gesture.state == .began {
      startY = point.y
    }
    
    let newY = point.y
    let goingToBottom = startY < newY
    let rangeReached = abs(startY - newY) > 30
    
    if rangeReached {
      gesture.isEnabled = false
      if goingToBottom, swipedView === headerView?.scalableView {
        guard !isBeingDismissed else { return }
        dismissViewController()
      }
      startY = newY
    }
    swipedView = view
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
