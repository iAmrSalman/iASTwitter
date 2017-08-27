//
//  LoginVC.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/26/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit
import TwitterKit
import PKHUD

class LoginVC: BaseViewController {
  
  //MARK: - Properties
  
  var user = User()
  var loginBtn: TWTRLogInButton!
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    login()
    
    NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
  }
  

  //MARK: - Helpers
  
  func login() {
    let loginButton = user.loginButton()
    self.loginBtn = loginButton
    self.loginBtn.center = self.view.center
    self.view.addSubview(self.loginBtn)
  }
  
  func rotated() {
    self.loginBtn.center = self.view.center
  }
}
