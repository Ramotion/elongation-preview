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
  internal convenience init(presenting: Bool) {
    self.init()
    self.presenting = presenting
  }
  
  // MARK: Properties
  var presenting :Bool = false

  fileprivate var elongationConfig: ElongationConfig { return ElongationConfig.shared }

  
  /// used whenever you need to get some settings (Configured at the AppDelegate) about the framework.
  lazy var animationDuration : TimeInterval = {
        [unowned self] in
        return self.presenting ? self.elongationConfig.detailPresetingDuration : self.elongationConfig.detailDismissingDuration
  }()
   
    
  /// an instance of the ElongationConfig Singleton.
  fileprivate var appearance: ElongationConfig { return ElongationConfig.shared }
  
  fileprivate let additionalOffsetY: CGFloat = 30
  

}

// MARK: - Transition Protocol Implementation
extension ElongationTransition: UIViewControllerAnimatedTransitioning {
  
  /// :nodoc:
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return presenting ? appearance.detailPresetingDuration : appearance.detailDismissingDuration
  }
  
  /// :nodoc:
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromVC        = transitionContext.viewController(forKey: .from)!

    // presenting is true when the animation comes from an ElongationDetailViewController instance. I preffer to leave the variable as the original repo even now is not much intuitive the description.
    presenting = !(fromVC .isKind(of: ElongationDetailViewController.self))

    presenting ? present(using: transitionContext) : dismiss(using: transitionContext)
  }
  
}

// MARK: - Presenting Animation
extension ElongationTransition {
  
  fileprivate func present(using context: UIViewControllerContextTransitioning) {
    
    var fromVC        = context.viewController(forKey: .from)!
    let containerView = context.containerView
    let toVC          = context.viewController(forKey: .to)!
    
    
    if ( fromVC is UINavigationController) {
        
        let filter = fromVC.childViewControllers.filter{$0.isKind(of: ElongationViewController.self)}
        fromVC = filter[0] as! ElongationViewController
        
    }else if (fromVC is UITabBarController ){
        fromVC = (fromVC as! UITabBarController).selectedViewController as! ElongationViewController
    }
    
    
    
    let sourceVC = fromVC as! ElongationViewController// ElongationViewController
    let destinationVC = toVC as! ElongationDetailViewController// ElongationDetailViewController
    
    
    let detailViewFinalFrame = context.finalFrame(for: destinationVC) // Final frame for presenting view controller
    
    guard
        // get expanded or selected indexPath
        let path = sourceVC.expandedIndexPath ?? sourceVC.tableView.indexPathForSelectedRow,
        // get expanded cell from root `tableView`
        let cell = sourceVC.tableView.cellForRow(at: path) as? ElongationCell
        else { return }
    
    // Determine are `root` view is in expanded state.
    // We need to know that because animation depends on the state.
    let isExpanded = sourceVC.state == .expanded
    
    
    // Create `ElongationHeader` from `ElongationCell` and set it as `headerView` to `detail` view controller
    let header = cell.elongationHeader
    destinationVC.headerView = header
    
    // Get frame of expanded cell and convert it to `containerView` coordinates
    let rect = sourceVC.tableView.rectForRow(at: path)
    let cellFrame = sourceVC.tableView.convert(rect, to: containerView)
    
    // Whole view snapshot
    UIGraphicsBeginImageContextWithOptions(toVC.view.bounds.size, false, 0)
    toVC.view.drawHierarchy(in: toVC.view.bounds, afterScreenUpdates: true)
    let fullImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    
    
    // Header snapshot
    UIGraphicsBeginImageContextWithOptions(header.frame.size, true, 0)
    fullImage.draw(at: CGPoint(x: 0, y: 0))
    let headerSnapsot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    // TableView snapshot
    let cellsSize = CGSize(width: toVC.view.frame.width, height: toVC.view.frame.height - header.frame.height)
    UIGraphicsBeginImageContextWithOptions(cellsSize, true, 0)
    fullImage.draw(at: CGPoint(x: 0, y: -header.frame.height))
    let tableSnapshot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    
    let headerSnapshotView = UIImageView(image: headerSnapsot)
    let tableViewSnapshotView = UIImageView(image: tableSnapshot)
    
    let tempView = UIView()
    tempView.backgroundColor = header.bottomView.backgroundColor
    
    // Add coming `view` to temporary `containerView`
    containerView.addSubview(toVC.view)
    containerView.addSubview(tempView)
    containerView.addSubview(tableViewSnapshotView)
    
    // Update `bottomView`s top constraint and invalidate layout
    header.bottomViewTopConstraint.constant = elongationConfig.topViewHeight
    header.bottomView.setNeedsLayout()
    
    let height = isExpanded ? cellFrame.height : elongationConfig.topViewHeight + elongationConfig.bottomViewHeight
    
    toVC.view.frame = CGRect(x: 0, y: cellFrame.minY, width: detailViewFinalFrame.width, height: cellFrame.height)
    
    headerSnapshotView.frame = CGRect(x: 0, y: cellFrame.minY, width: cellFrame.width, height: height)
    
    tableViewSnapshotView.frame = CGRect(x: 0, y: detailViewFinalFrame.maxY, width: cellsSize.width, height: cellsSize.height)
    
    tempView.frame = CGRect(x: 0, y: cellFrame.maxY, width: detailViewFinalFrame.width, height: 0)
    
    // Animate to new state
    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
        sourceVC.view?.alpha = 0
        
        header.scalableView.transform = .identity // reset scale to 1.0
        header.contentView.frame = CGRect(x: 0, y: 0, width: cellFrame.width, height: cellFrame.height + self.elongationConfig.bottomViewOffset)
        
        header.contentView.setNeedsLayout()
        header.contentView.layoutIfNeeded()
        
        toVC.view.frame = detailViewFinalFrame
        headerSnapshotView.frame = CGRect(x: 0, y: 0, width: cellFrame.width, height: height)
        tableViewSnapshotView.frame = CGRect(x: 0, y: header.frame.height, width: detailViewFinalFrame.width, height: cellsSize.height)
        tempView.frame = CGRect(x: 0, y: headerSnapshotView.frame.maxY, width: detailViewFinalFrame.width, height: detailViewFinalFrame.height)
    }) { (completed) in
        //rootView?.removeFromSuperview()
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
    
    let fromVC        = context.viewController(forKey: .from)!
    let containerView = context.containerView
    var toVC          = context.viewController(forKey: .to)
    
    if ( toVC is UINavigationController) {
        
        let filter = toVC?.childViewControllers.filter{$0.isKind(of: ElongationViewController.self)}
        toVC = filter?[0] as! ElongationViewController
        
    }else if (toVC is UITabBarController ){
        toVC = (toVC as! UITabBarController).selectedViewController as! ElongationViewController
    }
    
    
    let sourceVC = fromVC as! ElongationDetailViewController// ElongationViewController
    let destinationVC = toVC as! ElongationViewController// ElongationDetailViewController
    
    
    guard
        let header = sourceVC.headerView,
        let view = fromVC.view, // actual view of `detail` view controller
        let rootTableView = destinationVC.tableView, // `tableView` of root view controller
        let detailTableView = sourceVC.tableView, // `tableView` of detail view controller
        let path = destinationVC.expandedIndexPath ?? rootTableView.indexPathForSelectedRow, // `indexPath` of expanded or selected cell
        let expandedCell = rootTableView.cellForRow(at: path) as? ElongationCell
        else { return }
    
    // Collapse root view controller without animation
    destinationVC.collapseCells(animated: false)
    expandedCell.topViewTopConstraint.constant = 0
    expandedCell.topViewHeightConstraint.constant = elongationConfig.topViewHeight
    expandedCell.hideSeparator(false, animated: true)
    expandedCell.topView.setNeedsLayout()
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    
    let yOffset = detailTableView.contentOffset.y
    let topViewSize = CGSize(width: view.bounds.width, height: elongationConfig.topViewHeight)
    UIGraphicsBeginImageContextWithOptions(topViewSize, true, 0)
    header.topView.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: topViewSize), afterScreenUpdates: true)
    let topViewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let bottomViewSize = CGSize(width: view.bounds.width, height: elongationConfig.bottomViewHeight)
    UIGraphicsBeginImageContextWithOptions(bottomViewSize, true, 0)
    header.bottomView.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: bottomViewSize), afterScreenUpdates: true)
    let bottomViewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let size = CGSize(width: view.bounds.width, height: view.bounds.height - header.frame.height)
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    image.draw(at: CGPoint(x: 0, y: -header.frame.height))
    let tableViewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let bottomViewImageView = UIImageView(image: bottomViewImage)
    let topViewImageView = UIImageView(image: topViewImage)
    let tableViewSnapshotView = UIImageView(image: tableViewImage)
    
    
    // Add `header` and `tableView` snapshot to temporary container
    containerView.addSubview(bottomViewImageView)
    containerView.addSubview(tableViewSnapshotView)
    containerView.addSubview(topViewImageView)
    
    
    // Prepare view to dismissing
    let rect = rootTableView.rectForRow(at: path)
    let cellFrame = rootTableView.convert(rect, to: containerView)
    detailTableView.alpha = 0
    
    // Place views at their start points.
    topViewImageView.frame = CGRect(x: 0, y: -yOffset, width: topViewSize.width, height: topViewSize.height)
    bottomViewImageView.frame = CGRect(x: 0, y: -yOffset + topViewSize.height, width: view.bounds.width, height: bottomViewSize.height)
    tableViewSnapshotView.frame = CGRect(x: 0, y: header.frame.maxY - yOffset, width: view.bounds.width, height: tableViewSnapshotView.frame.height)
    
    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
        destinationVC.view?.alpha = 1
        tableViewSnapshotView.alpha = 0
        
        // Animate views to collapsed cell size
        let collapsedFrame = CGRect(x: 0, y: cellFrame.origin.y, width: header.frame.width, height: cellFrame.height)
        topViewImageView.frame = collapsedFrame
        bottomViewImageView.frame = collapsedFrame
        tableViewSnapshotView.frame = collapsedFrame
        expandedCell.contentView.layoutIfNeeded()
    }, completion: { (completed) in
        destinationVC.state = .normal
        destinationVC.expandedIndexPath = nil
        context.completeTransition(completed)
    })
    
  }
  
}
