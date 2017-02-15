//
//  ElongationViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class ElongationViewController: UITableViewController {
  
  // MARK: Public properties
  
  /// `IndexPath` of expanded cell.
  public var expandedIndexPath: IndexPath?
  
  /// Should cell change it's state to `expand` on tap.
  /// Default value: `true`
  public var shouldExpand = true
  
  public enum State {
    case normal, expanded
  }
  
  /// Current view state.
  /// Default value: `.normal`
  public var state: State = .normal {
    didSet {
      let expanded = state == .expanded
      tapGesture.isEnabled = expanded
      tableView.isScrollEnabled = !expanded
    }
  }
  
  // MARK: Private properties
  fileprivate var cellStatesDictionary: [IndexPath: Bool] = [:]
  fileprivate var tapGesture: UITapGestureRecognizer!
  
}

// MARK: - Lifecycle 🌎
extension ElongationViewController {
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
}

// MARK: - Setup ⛏
private extension ElongationViewController {
  
  func setup() {
    setupTableView()
    setupTapGesture()
  }
  
  private func setupTableView() {
    tableView.separatorStyle = .none
  }
  
  private func setupTapGesture() {
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(_:)))
    tapGesture.isEnabled = false
    tableView.addGestureRecognizer(tapGesture)
  }
  
}

// MARK: - Actions ⚡
extension ElongationViewController {
  
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
    
    let elongationCellTouchAction = ElongationConfig.shared.cellTouchAction
    
    guard let touchedView = cell.hitTest(point, with: nil) else {
      collapseCells()
      return
    }
    
    switch touchedView {
    case cell.bottomView:
      
      switch elongationCellTouchAction {
      case .expandOnBoth, .expandOnBottom, .collapseOnTopExpandOnBottom:
        openDetailView(for: path)
      case .collapseOnBoth, .collapseOnBottomExpandOnTop: collapseCells()
      default: break
      }
      
    case cell.scalableView:
      switch elongationCellTouchAction {
      case .collapseOnBoth, .collapseOnTopExpandOnBottom: collapseCells()
      case .collapseOnBottomExpandOnTop, .expandOnBoth, .expandOnTop: openDetailView(for: path)
      default: break
      }
      
    default:
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
    cell.expand(shouldExpand, animated: animated)
    cellStatesDictionary[indexPath] = shouldExpand
    
    // Change `self` properties
    state = shouldExpand ? .expanded : .normal
    expandedIndexPath = shouldExpand ? indexPath : nil
    
    // Fade in overlay view on visible cells except expanding one
    for case let elongationCell as ElongationCell in tableView.visibleCells where elongationCell != cell {
      elongationCell.dim(shouldExpand)
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
      tableView.scrollToRow(at: indexPath, at: .middle, animated: animated)
    }
  }
  
  fileprivate func changeOffset(of cell: ElongationCell) {
    let cellFrame = cell.frame
    let cellFrameInTable = tableView.convert(cellFrame, to: UIScreen.main.coordinateSpace)
    let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
    let tableHeight = tableView.bounds.size.height + cellFrameInTable.size.height
    let cellOffsetFactor = cellOffset / tableHeight
    cell.setFrontViewOffset(cellOffsetFactor)
  }
  
}

// MARK: - TableView 📚
extension ElongationViewController {
  
  open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ElongationCell else { return }
    let expanded = state == .expanded
    cell.dim(expanded, animated: expanded)
    changeOffset(of: cell)
  }
  
  open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard shouldExpand else { return }
    moveCells(from: indexPath)
  }
  
  open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let isExpanded = cellStatesDictionary[indexPath] ?? false
    let apperance = ElongationConfig.shared
    let frontViewHeight = apperance.topViewHeight
    let expandedCellHeight = apperance.bottomViewHeight + frontViewHeight - apperance.bottomViewOffset
    return isExpanded ? expandedCellHeight : frontViewHeight
  }
  
  open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView === tableView else { return }
    for case let cell as ElongationCell in tableView.visibleCells {
      changeOffset(of: cell)
    }
  }
 
}
