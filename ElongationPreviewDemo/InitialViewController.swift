//
//  InitialViewController.swift
//  ElongationPreview
//
//  Created by boris on 23/8/17.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
class InitialViewController: UIViewController {
    
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func NavigationControllerAction(_ sender: Any) {
        userDefaults.set("NCStoryBoard", forKey: "storyboard_name")
    }
    

    
    @IBAction func tabBarAction(_ sender: Any) {
            userDefaults.set("TabBStoryBoard", forKey: "storyboard_name")
    }
    
    
    
}
