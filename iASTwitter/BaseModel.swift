//
//  BaseModel.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/18/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
  
  //MARK: - Properties
  
  let appDelegate = UIApplication.shared.delegate
  
  //MARK: - Helpers
  
  func hijackWindow(withStoryBoardname storyboardname: String) {
    let vc = UIViewController.viewController(withStoryBoardname: storyboardname)
    guard let window = UIApplication.shared.keyWindow else { return }
    guard let rootViewController = window.rootViewController else { return }
    
    vc?.view.frame = rootViewController.view.frame
    vc?.view.layoutIfNeeded()

    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
      window.rootViewController = vc
      window.makeKeyAndVisible()
    }, completion: nil)
  }
}
