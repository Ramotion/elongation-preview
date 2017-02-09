//
//  AppDelegate.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Add dark view behind the status bar
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
      let view = UIView(frame: UIApplication.shared.statusBarFrame)
      view.backgroundColor = UIColor.black
      view.alpha = 0.4
      self.window?.addSubview(view)
      self.window?.bringSubview(toFront: view)
    }
    
    // Customize ElongationAppearance
    var apperance = ElongationAppearance.defaultAppearance
    apperance.backViewOffset = 0
    apperance.frontViewScaleFactor = 0.8
    ElongationAppearance.defaultAppearance = apperance
    
    return true
  }
  
}
