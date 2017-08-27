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
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  //MARK: - Actions
  
  @IBAction func login(_ sender: Any) {
    user.login()
  }
}
