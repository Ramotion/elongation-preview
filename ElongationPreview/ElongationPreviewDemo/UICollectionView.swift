//
//  UICollectionView.swift
//  bulugh-al-Maram
//
//  Created by Abdurahim Jauzee on 02/11/2016.
//  Copyright © 2016 Jawziyya. All rights reserved.
//

import UIKit


extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_: T.Type) {
    register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
  }
  
  func registerNib<T: UICollectionViewCell>(_:T.Type) {
    let nib = UINib(nibName: String(describing: T.self), bundle: nil)
    register(nib, forCellWithReuseIdentifier: String(describing: T.self))
  }
  
  func dequeue<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
    return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
  }
  
}
