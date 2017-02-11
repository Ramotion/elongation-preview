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
  public var expandedIndexPath: IndexPath?
  
  public enum State {
    case normal, expanded
  }
  
  public var state: State = .normal {
    didSet {
      let expanded = state == .expanded
      tapGesture.isEnabled = expanded
      tableView.isScrollEnabled = !expanded
      tableView.backgroundColor = expanded ? UIColor.black : UIColor.white
      //    tableView.allowsSelection = !expanded
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
  public func openDetailView(for indexPath: IndexPath) {
    print(#function, indexPath)
  }
  
  // MARK: Private
  @objc fileprivate func tableViewTapped(_ gesture: UITapGestureRecognizer) {
    guard let path = expandedIndexPath else { return }
    
    let location = gesture.location(in: tableView)
    let realPoint = tableView.convert(location, to: UIScreen.main.coordinateSpace)
    
    let cellFrame = tableView.rectForRow(at: path).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
    
    if realPoint.y < cellFrame.minY || realPoint.y > cellFrame.maxY {
      collapseCells()
    }
    
    guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) as? ElongationCell else { return }
    let point = cell.convert(location, from: tableView)
    
    guard let touchedView = cell.hitTest(point, with: nil) else { return }
    switch touchedView {
    case cell.backView: openDetailView(for: path)
    default: collapseCells()
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
  
}

// MARK: - TableView 📚
extension ElongationViewController {
  
  open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ElongationCell else { return }
    let expanded = state == .expanded
    cell.dim(expanded, animated: expanded)
  }
  
  open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    moveCells(from: indexPath)
  }
  
  open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let isExpanded = cellStatesDictionary[indexPath] ?? false
    let apperance = ElongationAppearance.defaultAppearance
    let frontViewHeight = apperance.frontViewHeight
    let expandedCellHeight = apperance.backViewHeight + frontViewHeight - apperance.backViewOffset
    return isExpanded ? expandedCellHeight : frontViewHeight
  }
 
}
