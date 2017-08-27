//
//  UIImageExtension.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/27/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit

extension UIImage {
  class func with(color: UIColor, size: CGSize) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}
