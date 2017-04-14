//
//  ElongationViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit

@available(iOS 10, *)
fileprivate var interaction: UIPreviewInteraction!

/**
 
 UITableViewController subclass.
 
 This is the `root` view controller which displays vertical stack of cards.
 Each card in stack can be expanded.
 
 */
open class ElongationViewController: SwipableTableViewController {
  
  // MARK: Public properties
  
  /// `IndexPath` of expanded cell.
  public var expandedIndexPath: IndexPath?
  
  /// Should cell change it's state to `expand` on tap.
  /// Default value: `true`
  public var shouldExpand = true
  
  /// Represents view state.
  public enum State {
    /// View in normal state. All cells `collapsed`.
    case normal
    /// View in `expanded` state. One of the cells is in `expanded` state.
    case expanded
  }
  
  /// Current view state.
  /// Default value: `.normal`
  public var state: State = .normal {
    didSet {
      let expanded = state == .expanded
      tapGesture.isEnabled = expanded
      tableView.allowsSelection = !expanded
      tableView.panGestureRecognizer.isEnabled = !expanded
    }
  }
  
  // MARK: Private properties
  fileprivate var cellStatesDictionary: [IndexPath: Bool] = [:]
  fileprivate var tapGesture: UITapGestureRecognizer!
  fileprivate var longPressGesture: UILongPressGestureRecognizer!
  fileprivate var config: ElongationConfig {
    return ElongationConfig.shared
  }
  fileprivate var parallaxConfigured = false
  fileprivate var shouldCommitPreviewAction = false
  
  // MARK: Lifecycle 🌎
  /// :nodoc:
  override open func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  /// :nodoc:
  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // We need to call this method to set parallax start offset
    guard config.isParallaxEnabled, !parallaxConfigured else { return }
    parallaxConfigured = true
    scrollViewDidScroll(tableView)
  }
  

  // MARK: - Actions ⚡
  // MARK: Public
  
  /// Collapse expanded cell.
  ///
  /// - Parameter animated: should animate changing tableView's frame.
  public func collapseCells(animated: Bool = true) {
    for (path, state) in cellStatesDictionary where state {
      moveCells(from: path, force: false, animated: animated)
    }
  }
  
  /// Expand cell at given `IndexPath`.
  /// View must be in `normal` state.
  ///
  /// - Parameter indexPath: IndexPath of target cell
  public func expandCell(at indexPath: IndexPath) {
    guard state == .normal else {
      print("The view is in `expanded` state already. You must collapse the cells before calling this method.")
      return
    }
    moveCells(from: indexPath, force: true)
  }
  
  /// Present modal view controller for cell at given `IndexPath`.
  ///
  /// - Parameter indexPath: IndexPath of source cell.
  open func openDetailView(for indexPath: IndexPath) {
    let viewController = ElongationDetailViewController(nibName: nil, bundle: nil)
    expand(viewController: viewController)
  }
  
  /// Expand given `ElongationDetailViewController`
  ///
  /// - Parameters:
  ///   - viewController: `ElongationDetailViewController` subclass which will be added to view hierarchy.
  ///   - animated: Should the transition be animated.
  ///   - completion: Optional callback which will be called when transition completes.
  public func expand(viewController: ElongationDetailViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
    viewController.modalPresentationStyle = .custom
    viewController.transitioningDelegate = self
    present(viewController, animated: animated, completion: completion)
  }
  
  // MARK: Private
  @objc fileprivate func tableViewTapped(_ gesture: UITapGestureRecognizer) {
    guard let path = expandedIndexPath else { return }
    
    let location = gesture.location(in: tableView)
    let realPoint = tableView.convert(location, to: UIScreen.main.coordinateSpace)
    
    let cellFrame = tableView.rectForRow(at: path).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
    
    if realPoint.y < cellFrame.minY || realPoint.y > cellFrame.maxY {
      collapseCells()
      return
    }
    
    guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) as? ElongationCell else { return }
    let point = cell.convert(location, from: tableView)
    
    let elongationCellTouchAction = config.cellTouchAction
    
    guard let touchedView = cell.hitTest(point, with: nil) else {
      collapseCells()
      return
    }
    
    if touchedView === cell.bottomView || touchedView.superview === cell.bottomView {
      switch elongationCellTouchAction {
      case .expandOnBoth, .expandOnBottom, .collapseOnTopExpandOnBottom:
        openDetailView(for: path)
      case .collapseOnBoth, .collapseOnBottomExpandOnTop: collapseCells()
      default: break
      }
    } else if touchedView === cell.scalableView || touchedView.superview === cell.scalableView || touchedView.superview === cell.topView || touchedView === cell.topView {
      switch elongationCellTouchAction {
      case .collapseOnBoth, .collapseOnTopExpandOnBottom: collapseCells()
      case .collapseOnBottomExpandOnTop, .expandOnBoth, .expandOnTop: openDetailView(for: path)
      default: break
      }
    } else {
      switch elongationCellTouchAction {
      case .expandOnBoth: openDetailView(for: path)
      case .collapseOnBoth: collapseCells()
      default: break
      }
    }
    
  }
  
  fileprivate func moveCells(from indexPath: IndexPath, force: Bool? = nil, animated: Bool = true) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ElongationCell else { return }
    let shouldExpand = force ?? !(cellStatesDictionary[indexPath] ?? false)
    shouldCommitPreviewAction = false
    cell.expand(shouldExpand, animated: animated) { _ in
      self.shouldCommitPreviewAction = true
    }
    cellStatesDictionary[indexPath] = shouldExpand
    
    // Change `self` properties
    state = shouldExpand ? .expanded : .normal
    expandedIndexPath = shouldExpand ? indexPath : nil
    
    // Fade in overlay view on visible cells except expanding one
    for case let elongationCell as ElongationCell in tableView.visibleCells where elongationCell != cell {
      elongationCell.dim(shouldExpand)
      elongationCell.hideSeparator(shouldExpand, animated: animated)
    }
    
    if !animated {
      UIView.setAnimationsEnabled(false)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
    if !animated {
      UIView.setAnimationsEnabled(true)
    }
    
    // Scroll to calculated rect only if it's not going to collapse whole tableView
    if force == nil {
      let cellFrame = cell.frame
      let scrollToFrame = cellFrame
      if scrollToFrame.maxY > tableView.contentSize.height {
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
      } else {
        tableView.scrollRectToVisible(scrollToFrame, animated: animated)
      }
    }
    
    guard !shouldExpand else { return }
    for case let elongationCell as ElongationCell in tableView.visibleCells where elongationCell != cell {
      elongationCell.parallaxOffset(offsetY: tableView.contentOffset.y, height: tableView.bounds.height)
    }
    
  }
  
  /// :nodoc:
  override func gestureRecognizerSwiped(_ gesture: UIPanGestureRecognizer) {
    guard config.isSwipeGesturesEnabled else { return }
    let point = gesture.location(in: tableView)
    guard let path = tableView.indexPathForRow(at: point), path == expandedIndexPath, let cell = tableView.cellForRow(at: path) as? ElongationCell else {
      swipedView = nil
      return
    }
    let convertedPoint = cell.convert(point, from: tableView)
    if gesture.state == .began {
      if cell.scalableView.frame.contains(convertedPoint) {
        swipedView = cell.scalableView
      } else if cell.bottomView.frame.contains(convertedPoint) {
        swipedView = cell.bottomView
      } else {
        swipedView = nil
        return
      }
      startY = convertedPoint.y
    }
    guard let swipedView = swipedView else { return }
    
    let newY = convertedPoint.y
    let goingToBottom = startY < newY
    
    let rangeReached = abs(startY - newY) > 50
    if swipedView == cell.scalableView && rangeReached {
      if goingToBottom {
        collapseCells(animated: true)
      } else {
        openDetailView(for: path)
      }
      startY = newY
    } else if swipedView == cell.bottomView && rangeReached {
      if goingToBottom {
        openDetailView(for: path)
      } else {
        collapseCells(animated: true)
      }
      startY = newY
    }
  }
  
  @objc fileprivate func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: tableView)
    guard sender.state == .began, let path = tableView.indexPathForRow(at: location) else { return }
    expandedIndexPath = path
    moveCells(from: path)
  }
  
}

// MARK: - Setup ⛏
private extension ElongationViewController {
  
  // MARK: - Setup ⛏
  func setup() {
    setupTableView()
    setupTapGesture()
    
    if #available(iOS 10, *), traitCollection.forceTouchCapability == .available, config.forceTouchPreviewInteractionEnabled {
      interaction = UIPreviewInteraction(view: view)
      interaction.delegate = self
    } else if config.forceTouchPreviewInteractionEnabled {
      setupLongPressGesture()
    }
  }
  
  private func setupTableView() {
    tableView.separatorStyle = .none
  }
  
  private func setupTapGesture() {
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(_:)))
    tapGesture.isEnabled = false
    tableView.addGestureRecognizer(tapGesture)
  }
  
  private func setupLongPressGesture() {
    longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
    tableView.addGestureRecognizer(longPressGesture)
  }
  
  
}

// MARK: - TableView 📚
extension ElongationViewController {
  
  /// Must call `super` if you override this method in subclass.
  open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ElongationCell else { return }
    let expanded = state == .expanded
    cell.dim(expanded, animated: true)
    
    // Remove separators from top and bottom cells.
    guard config.customSeparatorEnabled else { return }
    cell.hideSeparator(expanded, animated: expanded)
    let numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
    if indexPath.row == 0 || indexPath.row == numberOfRowsInSection - 1 {
      let separator = indexPath.row == 0 ? cell.topSeparatorLine : cell.bottomSeparatorLine
      separator?.backgroundColor = UIColor.black
    } else {
      cell.topSeparatorLine?.backgroundColor = config.separatorColor
      cell.bottomSeparatorLine?.backgroundColor = config.separatorColor
    }
  }
  
  /// :nodoc:
  open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard shouldExpand else { return }
    DispatchQueue.main.async {
      self.expandedIndexPath = indexPath
      self.openDetailView(for: indexPath)
    }
  }
  
  /// :nodoc:
  open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let isExpanded = cellStatesDictionary[indexPath] ?? false
    let frontViewHeight = config.topViewHeight
    let expandedCellHeight = config.bottomViewHeight + frontViewHeight - config.bottomViewOffset
    return isExpanded ? expandedCellHeight : frontViewHeight
  }
  
  /// Must call `super` if you override this method in subclass.
  open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView === tableView, config.isParallaxEnabled else { return }
    for case let cell as ElongationCell in tableView.visibleCells {
      cell.parallaxOffset(offsetY: tableView.contentOffset.y, height: tableView.bounds.height)
    }
  }
  
}

// MARK: - 3D Touch Preview Interaction
@available(iOS 10.0, *)
extension ElongationViewController: UIPreviewInteractionDelegate {
  
  /// :nodoc:
  public func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
    collapseCells()
    
    panGestureRecognizer.isEnabled = true
    
    // This trick will prevent expanding cell in `didSelectRowAt indexPath` method
    tableView.allowsSelection = false
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
      self.tableView.allowsSelection = true
    }
  }
  
  /// :nodoc:
  public func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
    guard ended else { return }
    panGestureRecognizer.isEnabled = false
    let location = previewInteraction.location(in: tableView)
    guard let path = tableView.indexPathForRow(at: location) else { return }
    if path == expandedIndexPath {
      openDetailView(for: path)
      previewInteraction.cancel()
    } else {
      moveCells(from: path)
    }
  }
  
  /// :nodoc:
  public func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdateCommitTransition transitionProgress: CGFloat, ended: Bool) {
    guard ended else { return }
    guard let path = expandedIndexPath else { return }
    panGestureRecognizer.isEnabled = false
    if shouldCommitPreviewAction {
      openDetailView(for: path)
    } else {
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
        self.openDetailView(for: path)
      }
    }
  }
  
}

// MARK: - Transition
extension ElongationViewController: UIViewControllerTransitioningDelegate {
  
  /// This transition object will be used while dismissing `ElongationDetailViewController`.
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ElongationTransition(presenting: false)
  }
  
  /// This transition object will be used while presenting `ElongationDetailViewController`.
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ElongationTransition(presenting: true)
  }
  
}
