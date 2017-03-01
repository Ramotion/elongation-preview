
//
//  UITableView.swift
//  sahihBukhari
//
//  Created by Abdurahim Jauzee on 25/07/16.
//  Copyright © 2016 Jawziyya. All rights reserved.
//

import UIKit

/// :nodoc:
public extension UITableView {
  
  /// Register given `UITableViewCell` in tableView.
  /// Cell will be registered with the name of it's class as identifier.
  public func register<T: UITableViewCell>(_: T.Type) {
    register(T.self, forCellReuseIdentifier: String(describing: T.self))
  }
  
  /// Register given `UITableViewCell` in tableView.
  /// Cell will be registered with the name of it's class as identifier.
  public func registerNib<T: UITableViewCell>(_:T.Type) {
    let nib = UINib(nibName: String(describing: T.self), bundle: nil)
    register(nib, forCellReuseIdentifier: String(describing: T.self))
  }
  
  /// Dequeue cell of given class from tableView.
  public func dequeue<T: UITableViewCell>(_: T.Type) -> T {
    return dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T ?? T()
  }

}
