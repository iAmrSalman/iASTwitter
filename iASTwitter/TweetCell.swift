//
//  TweetCell.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/27/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  //MARK: - Outlets
  
  @IBOutlet private weak var tweetLbl: UILabel!
  
  //MARK: - Configuration
  
  func configure(_ tweet: String) {
    tweetLbl.text = tweet
  }
}
