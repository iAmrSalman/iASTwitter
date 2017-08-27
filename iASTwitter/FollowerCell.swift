//
//  FollowerCell.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/27/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit
import Kingfisher

class FollowerCell: UITableViewCell {
  
  //MARK: - Outlets
  
  @IBOutlet private weak var profileImg: UIImageView!
  @IBOutlet private weak var usernameLbl: UILabel!
  @IBOutlet private weak var bioLbl: UILabel!
  
  //MARK: - Life cycle 
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    profileImg.shape = .circular
  }
  
  //MARK: - Configuration
  
  func configure(_ user: User) {
    profileImg.kf.setImage(with: URL(string: user.profileImageURL), placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(ImageTransition.fade(1))])
    usernameLbl.text = "@\(user.username)"
    bioLbl.text = user.bio
    if user.isKilled {
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "@\(user.username)")
      attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
      usernameLbl.attributedText = attributeString
    }
  }
}
