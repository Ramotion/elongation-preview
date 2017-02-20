//
//  SwipableTableViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 17/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class SwipableTableViewController: UITableViewController, UIGestureRecognizerDelegate {
  
  public var gestureRecognizer: UIPanGestureRecognizer!
  var startY: CGFloat = 0
  var swipedView: UIView?
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerSwiped(_:)))
    gestureRecognizer.delegate = self
    tableView.addGestureRecognizer(gestureRecognizer)
  }
  
  func gestureRecognizerSwiped(_ gesture: UIPanGestureRecognizer) { }
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
}
