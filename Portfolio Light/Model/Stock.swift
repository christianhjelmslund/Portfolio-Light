//
//  Stock.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 16/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class Stock: NSObject, Codable {

    struct StockData: Codable {
        var company: String
        var symbol: String
        var dateBought: String
        var amount: Int
        var buyingPrice: Double
    }
    
    var company: String
    var symbol: String
    var dateBought: String
    var amount: Int
    var buyingPrice: Double
    
    init(company: String, symbol: String, dateBought: String, buyingPrice: Double, amount: Int){
        self.company = company
        self.symbol = symbol
        self.dateBought = dateBought
        self.amount = amount
        self.buyingPrice = buyingPrice
    }
    
    func calculateLossOrProfit() -> Int{
        return 0
    }
}
