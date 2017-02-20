//
//  ElongationTransition.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 11/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


/// Provides transition animations between `ElongationViewController` & `ElongationDetailViewController`.
public class ElongationTransition: NSObject {
  
  // MARK: Constructor
  convenience init(presenting: Bool) {
    self.init()
    self.presenting = presenting
  }
  
  // MARK: Properties
  fileprivate var presenting = true
  fileprivate var appearance: ElongationConfig { return ElongationConfig.shared }
  
  fileprivate let additionalOffsetY: CGFloat = 30
  
  fileprivate var rootKey: UITransitionContextViewControllerKey {
    return presenting ? .from : .to
  }
  fileprivate var detailKey: UITransitionContextViewControllerKey {
    return presenting ? .to : .from
  }
  fileprivate var rootViewKey: UITransitionContextViewKey {
    return presenting ? .from : .to
  }
  fileprivate var detailViewKey: UITransitionContextViewKey {
    return presenting ? .to : .from
  }
  
  fileprivate func root(from context: UIViewControllerContextTransitioning) -> ElongationViewController {
    return context.viewController(forKey: rootKey) as? ElongationViewController ?? ElongationViewController(nibName: nil, bundle: nil)
  }
  
  fileprivate func detail(from context: UIViewControllerContextTransitioning) -> ElongationDetailViewController {
    return context.viewController(forKey: detailKey) as? ElongationDetailViewController ?? ElongationDetailViewController(nibName: nil, bundle: nil)
  }
  
}

// MARK: - Transition Protocol Implementation
extension ElongationTransition: UIViewControllerAnimatedTransitioning {
  
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return presenting ? appearance.detailPresetingDuration : appearance.detailDismissingDuration
  }
  
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    presenting ? present(using: transitionContext) : dismiss(using: transitionContext)
  }
  
}

// MARK: - Presenting Animation
extension ElongationTransition {
  
  fileprivate func present(using context: UIViewControllerContextTransitioning) {
    let duration = transitionDuration(using: context)
    let containerView = context.containerView
    let root = self.root(from: context) // ElongationViewController
    let detail = self.detail(from: context) // ElongationDetailViewController
    let rootView = context.view(forKey: rootViewKey)
    let detailView = context.view(forKey: detailViewKey)
    
    let detailViewFinalFrame = context.finalFrame(for: detail) // Final frame for presenting view controller
    
    guard
      let path = root.expandedIndexPath, // get expanded indexPath
      let rootTableView = root.tableView, // get `tableView` from root
      let cell = rootTableView.cellForRow(at: path) as? ElongationCell, // get expanded cell from root `tableView`
      let view = detailView // unwrap optional `detailView`
      else { return }

    // Create `ElongationHeader` from `ElongationCell` and set it as `headerView` to `detail` view controller
    let header = cell.elongationHeader
    detail.headerView = header
    
    // Whole view snapshot
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let fullImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    // Header snapshot
    UIGraphicsBeginImageContextWithOptions(header.frame.size, true, 0)
    fullImage.draw(at: CGPoint(x: 0, y: 0))
    let headerSnapsot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    // TableView snapshot
    let cellsSize = CGSize(width: view.frame.width, height: view.frame.height - header.frame.height)
    UIGraphicsBeginImageContextWithOptions(cellsSize, true, 0)
    fullImage.draw(at: CGPoint(x: 0, y: -header.frame.height))
    let tableSnapshot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    let headerSnapshotView = UIImageView(image: headerSnapsot)
    let tableViewSnapshotView = UIImageView(image: tableSnapshot)
    
    let tempView = UIView()
    tempView.backgroundColor = header.bottomView.backgroundColor
    
    // Add coming `view` to temporary `containerView`
    containerView.addSubview(view)
    containerView.addSubview(tempView)
    containerView.addSubview(tableViewSnapshotView)
    
    // Update `bottomView`s top constraint and invalidate layout
    header.bottomViewTopConstraint.constant = appearance.topViewHeight
    header.bottomView.setNeedsLayout()
    
    // Get frame of expanded cell and convert it to `containerView` coordinates
    let rect = rootTableView.rectForRow(at: path)
    let cellFrame = rootTableView.convert(rect, to: containerView)

    view.frame = CGRect(x: 0, y: cellFrame.minY, width: detailViewFinalFrame.width, height: cellFrame.height)
    headerSnapshotView.frame = CGRect(x: 0, y: cellFrame.minY, width: cellFrame.width, height: cellFrame.height)
    tableViewSnapshotView.frame = CGRect(x: 0, y: detailViewFinalFrame.maxY, width: cellsSize.width, height: cellsSize.height)
    tempView.frame = CGRect(x: 0, y: cellFrame.maxY, width: detailViewFinalFrame.width, height: 0)
    
    // Animate to new state
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
      root.view?.alpha = 0
      
      header.scalableView.transform = .identity // reset scale to 1.0
      header.contentView.frame = CGRect(x: 0, y: 0, width: cellFrame.width, height: cellFrame.height + self.appearance.bottomViewOffset)
      
      header.contentView.setNeedsLayout()
      header.contentView.layoutIfNeeded()
      
      view.frame = detailViewFinalFrame
      headerSnapshotView.frame = CGRect(x: 0, y: 0, width: cellFrame.width, height: cellFrame.height)
      tableViewSnapshotView.frame = CGRect(x: 0, y: header.frame.height, width: detailViewFinalFrame.width, height: cellsSize.height)
      tempView.frame = CGRect(x: 0, y: headerSnapshotView.frame.maxY, width: detailViewFinalFrame.width, height: detailViewFinalFrame.height)
    }) { (completed) in
      rootView?.removeFromSuperview()
      tempView.removeFromSuperview()
      headerSnapshotView.removeFromSuperview()
      tableViewSnapshotView.removeFromSuperview()
      context.completeTransition(completed)
    }
    
  }
  
}

// MARK: - Dismiss Animation
extension ElongationTransition {
  
  fileprivate func dismiss(using context: UIViewControllerContextTransitioning) {
    let root = self.root(from: context)
    let detail = self.detail(from: context)
    let containerView = context.containerView
    let duration = transitionDuration(using: context)
    
    guard
      let header = detail.headerView,
      let view = context.view(forKey: detailViewKey), // actual view of `detail` view controller
      let rootTableView = root.tableView, // `tableView` of root view controller
      let detailTableView = detail.tableView, // `tableView` of detail view controller
      let path = root.expandedIndexPath, // `indexPath` of expanded cell
      let expandedCell = rootTableView.cellForRow(at: path) as? ElongationCell
    else { return }
    
    // Collapse root view controller without animation
    root.collapseCells(animated: false)
    expandedCell.topViewTopConstraint.constant = 0
    expandedCell.topViewHeightConstraint.constant = appearance.topViewHeight
    expandedCell.hideSeparator(true, animated: false)
    
    let contentView = header.contentView
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    let size = CGSize(width: view.frame.width, height: view.frame.height - header.frame.height)
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    image.draw(at: CGPoint(x: 0, y: -header.frame.height))
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    let tableViewSnapshotView = UIImageView(image: croppedImage)
    
    
    // Add `header` and `tableView` snapshot to temporary container
    containerView.addSubview(tableViewSnapshotView)
    containerView.addSubview(header)
    
    
    // Prepare view to dismissing
    let rect = rootTableView.rectForRow(at: path)
    let cellFrame = rootTableView.convert(rect, to: containerView)
    detailTableView.alpha = 0
    
    // Place views at their start points.
    let offset = detailTableView.contentOffset.y
    header.frame = CGRect(x: 0, y: -offset, width: header.frame.width, height: header.frame.height)
    tableViewSnapshotView.frame = CGRect(x: 0, y: header.frame.maxY, width: view.bounds.width, height: tableViewSnapshotView.frame.height)
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
      root.view?.alpha = 1
      
      header.bottomViewTopConstraint.constant = self.appearance.bottomViewOffset
      header.bottomView.setNeedsLayout()
      
      tableViewSnapshotView.alpha = 0
      contentView.backgroundColor = UIColor.white
      
      // Animate views to collapsed cell size
      header.frame = CGRect(x: 0, y: cellFrame.origin.y, width: header.frame.width, height: cellFrame.height)
      contentView.frame = CGRect(x: 0, y: 0, width: header.frame.width, height: cellFrame.height)
      tableViewSnapshotView.frame = CGRect(x: 0, y: cellFrame.origin.y, width: view.bounds.width, height: cellFrame.height)
      
      // Invalidate `contentView` layout to update `backView`
      contentView.setNeedsLayout()
      contentView.layoutIfNeeded()
    }, completion: { (completed) in
      view.removeFromSuperview()
      context.completeTransition(completed)
    })
  }
  
}
