//
//  ElongationPreviewUITests.swift
//  ElongationPreviewUITests
//
//  Created by Abdurahim Jauzee on 17/03/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import XCTest
@testable import ElongationPreviewDemo


class ElongationPreviewUITests: XCTestCase {
  
  var viewController: UITableViewController!
  var detailViewController: UITableViewController!
  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
}
