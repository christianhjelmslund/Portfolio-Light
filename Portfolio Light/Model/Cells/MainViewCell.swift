//
//  MainViewCell.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 23/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {

   
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var priceNow: UILabel!
    @IBOutlet weak var boughtPrice: UILabel!
    @IBOutlet weak var amountOfStocks: UILabel!
    @IBOutlet weak var profitView: UIView!
    @IBOutlet weak var dateBought: UILabel!
    @IBOutlet weak var rawValueLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var stocknameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        bgView.backgroundColor = .myDark
        bgView.layer.cornerRadius = 15
        
        barView.backgroundColor = .myPurple
        stocknameLabel.textColor = .myPurple
        dateBought.textColor = .myLightPurple
        amountOfStocks.textColor = .myLightPurple
        boughtPrice.textColor = .myLightPurple
        priceNow.textColor = .myLightPurple
        
        bgView.layer.shadowColor = CGColor.myLightPurple
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 5
        
        profitView.backgroundColor = .myGreen
        profitView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        super.setSelected(selected, animated: animated)
    }
}
