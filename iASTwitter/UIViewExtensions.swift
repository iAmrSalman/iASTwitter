//
//  UIViewExtension.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/27/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var viewBorderColor: UIColor? {
    get {
      return self.viewBorderColor
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    get {
      return self.shadowColor
    }
    set {
      layer.shadowColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  public enum Shape {
    case rectangle
    case rounded(CGFloat)
    case circular
  }
  
  func circulerContent() {
    self.cornerRadius = self.bounds.height / 2
    layer.masksToBounds = true
    self.clipsToBounds = true
  }
  
  var shape: Shape? {
    get {
      return self.shape
    }
    
    set {
      setShape(newValue!)
    }
  }
  
  func setShape(_ shape: Shape) {
    switch shape {
    case .circular:
      circulerContent()
    case .rounded(let cornerRadius):
      self.cornerRadius = cornerRadius
    case .rectangle:
      self.cornerRadius = 0
    }
  }
  
  func setShadow(color: UIColor = .black, radius: CGFloat = 2, opacity: Float = 0.15, offset: CGSize = CGSize(width: 0, height: 1)) {
    shadowColor = color
    shadowRadius = radius
    shadowOpacity = opacity
    shadowOffset = offset
  }
  
  func shadowView(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize = CGSize(width: 0 , height: 0), shape: Shape) -> UIView {
    switch shape {
    case .circular:
      self.circulerContent()
    case .rounded(let cornerRadius):
      self.cornerRadius = cornerRadius
    default:
      self.cornerRadius = 0
    }
    let shadowView = UIView()
    shadowView.frame = self.frame
    shadowView.layer.shadowColor = color.cgColor
    shadowView.layer.shadowOffset = offset
    shadowView.layer.shadowRadius = radius
    shadowView.layer.shadowOpacity = opacity
    switch shape {
    case .rectangle:
      shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
    case .circular:
      shadowView.layer.shadowPath = UIBezierPath(ovalIn: shadowView.bounds).cgPath
    case .rounded(let cornerRadius):
      shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius).cgPath
    }
    shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
    return shadowView
  }
  
  func fadeIn(_ view: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
    UIView.transition(with: view, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      view.isHidden = false
    }, completion: completion)
  }
  
  func fadeOut(_ view: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
    UIView.transition(with: view, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      view.isHidden = true
    }, completion: completion)
  }
}
