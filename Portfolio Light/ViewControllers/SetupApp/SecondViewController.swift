//
//  SecondViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 15/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setGradientBackground()
        
        descriptionLabel.textColor = .myPurple
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        descriptionLabel.adjustsFontForContentSizeCategory = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

