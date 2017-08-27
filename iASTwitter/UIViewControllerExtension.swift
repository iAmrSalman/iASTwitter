//
//  UIViewControllerExtension.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/27/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // ## returns initialViewController `withStoryBoardname`
  class func viewController(withStoryBoardname storyBoardName : String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
    let controller = storyboard.instantiateInitialViewController()
    return controller
  }
  
  // ## returns viewController `withStoryBoardname` and `contollerID`
  class func viewController(withStoryBoardname storyBoardName : String , contollerID : String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
    let controller = storyboard.instantiateViewController(withIdentifier: contollerID)
    return controller
  }
  
}
