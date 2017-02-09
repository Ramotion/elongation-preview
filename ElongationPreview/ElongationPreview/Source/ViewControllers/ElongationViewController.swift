//
//  ElongationViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit


open class ElongationViewController: UITableViewController {
  
  public var cellStatesDictionary: [IndexPath: Bool] = [:]
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
  fileprivate var tapGesture: UITapGestureRecognizer!
  fileprivate var lastAppearedCell: ElongationCell? // For a workaround
  
}

// MARK: - Lifecycle 🌎
extension ElongationViewController {
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    setup()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = ElongationAppearance.defaultAppearance.frontViewHeight
  }
  
}

// MARK: - Setup ⛏
private extension ElongationViewController {
  
  func setup() {
    tableView.separatorStyle = .none
    setupTapGesture()
  }
  
  private func setupTapGesture() {
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(_:)))
    tapGesture.isEnabled = false
//    tableView.addGestureRecognizer(tapGesture)
  }
  
}

// MARK: - Actions ⚡
extension ElongationViewController {
  
  @objc fileprivate func tableViewTapped(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: tableView)
    let realPoint = tableView.convert(location, to: UIScreen.main.coordinateSpace)
    let height = UIScreen.main.bounds.height
    let expandedCellHeight: CGFloat = 335
    let topMaxY = (height - expandedCellHeight) / 2
    let bottomMinY = height - topMaxY
    if realPoint.y < topMaxY || realPoint.y > bottomMinY {
      for (path, _) in cellStatesDictionary {
        moveCells(from: path)
      }
    }
  }
  
  public func moveCells(from indexPath: IndexPath, force: Bool? = nil) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ElongationCell else { return }
    let shouldExpand = force ?? !(cellStatesDictionary[indexPath] ?? false)
    cell.expand(shouldExpand)
    cellStatesDictionary[indexPath] = shouldExpand
    
    // Change `self` properties
    state = shouldExpand ? .expanded : .normal
    
    tableView.beginUpdates()
    tableView.endUpdates()
    
    var scrollToRect = cell.frame
    
    //    let inset: CGFloat = shouldExpand ? 400 : 0
    if shouldExpand {
      expandedIndexPath = indexPath
      //      tableView.contentInset = UIEdgeInsets(top: inset, bottom: inset)
      let height = tableView.bounds.height
      
      scrollToRect.size.height = height
      scrollToRect.origin.y = scrollToRect.origin.y - ((height - cell.frame.height)/2)
    } else {
      expandedIndexPath = nil
      scrollToRect = cell.frame
      //      newRect.size.height = tableView.bounds.height
      //      newRect.origin.y = newRect.origin.y - 10  //(tableView.bounds.height)
      //      print(cell.frame)
      //      print(newRect)
      //      tableView.contentInset = UIEdgeInsets(top: inset, bottom: inset)
    }
    
    // Scroll to calculated rect only if it's not going to collapse whole tableView
    if force == nil {
      tableView.scrollRectToVisible(scrollToRect, animated: true)
    }
    
    // Fade in overlay view on visible cells except expanding one
    if var paths = tableView.indexPathsForVisibleRows, let last = paths.last {
      let bottomPath = IndexPath(row: last.row + 1, section: 0)
      paths.append(bottomPath)
      for path in paths where path != indexPath {
        guard let cell = tableView.cellForRow(at: path) as? ElongationCell else { continue }
        cell.dim(shouldExpand)
      }
      if lastAppearedCell != cell {
        lastAppearedCell?.dim(shouldExpand)
      }
    }
    
    
  }
  
  public func collapseCells() {
    for path in tableView.indexPathsForVisibleRows ?? [] {
      moveCells(from: path, force: false)
    }
  }
  
}

// MARK: - TableView 📚
extension ElongationViewController {
  
  open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ElongationCell else { return }
    lastAppearedCell = cell
    if state == .expanded {
      cell.dim(true, animated: true)
    } else {
      cell.dim(false, animated: true)
    }
  }
  
  open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath == expandedIndexPath || expandedIndexPath == nil else {
      collapseCells()
      return
    }
    moveCells(from: indexPath)
  }

}
