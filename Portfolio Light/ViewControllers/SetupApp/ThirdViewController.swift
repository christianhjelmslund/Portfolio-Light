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
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBAction func doneButtonAction(_ sender: Any) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainSB.instantiateViewController(withIdentifier: "addStockVC")
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
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
        
        doneButton.backgroundColor = .myDark
        doneButton.layer.cornerRadius = 15
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = .myPurple
        doneButton.setTitleColor(.myPurple, for: .normal)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

