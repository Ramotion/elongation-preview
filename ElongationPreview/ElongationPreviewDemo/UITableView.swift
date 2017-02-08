
//
//  UITableView.swift
//  sahihBukhari
//
//  Created by Abdurahim Jauzee on 25/07/16.
//  Copyright © 2016 Jawziyya. All rights reserved.
//

import UIKit


protocol TableViewConfigurable: UITableViewDelegate, UITableViewDataSource { }

extension UITableView {
  
  func setup(_ vc: TableViewConfigurable) {
    delegate = vc
    dataSource = vc
  }
  
  func register<T: UITableViewCell>(_: T.Type) {
    register(T.self, forCellReuseIdentifier: String(describing: T.self))
  }
  
  func registerNib<T: UITableViewCell>(_:T.Type) {
    let nib = UINib(nibName: String(describing: T.self), bundle: nil)
    register(nib, forCellReuseIdentifier: String(describing: T.self))
  }
  
  func dequeue<T: UITableViewCell>(_: T.Type) -> T {
    return dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T ?? T()
  }
  
  
  // MARK: Header & Footer
  func registerNibHeader<T: UIView>(_: T.Type) {
    let nib = UINib(nibName: String(describing: T.self), bundle: nil)
    register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
  }
  
  func dequeueHeaderFooter<T: UIView>(_: T.Type) -> T {
    return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
  }
  
}
