//
//  Colors.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 13/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let myLightPurple = UIColor(red: 216/255, green: 216/255, blue: 246/255, alpha: 1)
    static let myPurple = UIColor(red: 142/255, green: 142/255, blue: 206/255, alpha: 1)
    static let myGray = UIColor(red: 135/255, green: 135/255, blue: 150/255, alpha: 1)
    static let myDarkGray = UIColor(red: 71/255, green: 71/255, blue: 79/255, alpha: 1)
    static let myDark = UIColor(red: 43/255, green: 43/255, blue: 51/255, alpha: 1)
    static let myGreen = UIColor(red:103/255, green:211/255, blue:141/255, alpha: 1)
    static let errorColor = UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
}

extension CGColor {
    static let myLightPurple = UIColor(red: 216/255, green: 216/255, blue: 246/255, alpha: 1).cgColor
    static let myPurple = UIColor(red: 142/255, green: 142/255, blue: 206/255, alpha: 1).cgColor
    static let myGray = UIColor(red: 135/255, green: 135/255, blue: 150/255, alpha: 1).cgColor
    static let myDarkGray = UIColor(red: 71/255, green: 71/255, blue: 79/255, alpha: 1).cgColor
    static let myDark = UIColor(red: 43/255, green: 43/255, blue: 51/255, alpha: 1).cgColor
    static let myGreen = UIColor(red:103/255, green:211/255, blue:141/255, alpha: 1).cgColor
}

extension UIView {
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [CGColor.myDark, CGColor.myDarkGray, CGColor.myDark, CGColor.myDarkGray, CGColor.myDark]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [CGColor.myLightPurple, CGColor.myPurple]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
