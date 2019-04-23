//
//  ThirdViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 15/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setGradientBackground()
        bgView.backgroundColor = .myDark
        bgView.layer.cornerRadius = 15
        
        bgView.layer.shadowColor = .myPurple
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 10
        descriptionLabel.textColor = .myPurple
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

