//
//  ViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 13/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    let ap = AlphaVantageAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.view.setGradientBackground()
        
        titleLabel.textColor = .myPurple
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .myPurple
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        bottomLabel.textColor = .myPurple
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bottomLabel.adjustsFontForContentSizeCategory = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


