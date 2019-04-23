//
//  MainViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 23/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var spaceBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomInfoBar: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    private let defaults = UserDefaults.standard
    private let api = AlphaVantageAPI()
    private var stocks: [Stock] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getStocks()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        self.view.setGradientBackground()
        
        topViewBar.backgroundColor = .myPurple
        navigationBar.barTintColor = .myPurple
        tableView.separatorStyle = .none
        navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.myDark]
        navigationBar.titleTextAttributes = textAttributes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func getStocks(){
        guard let stocksData = defaults.object(forKey: "stocks") as? Data else { return }
        guard let fetchedStocks = try? PropertyListDecoder().decode([Stock].self, from: stocksData) else { return }
        stocks = fetchedStocks
        for stock in stocks {
            print(stock.company)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainViewCell") as! MainViewCell
        
        if let name = stocks[safe: indexPath.row]?.company, let dateBought = stocks[safe: indexPath.row]?.dateBought, let amount = stocks[safe: indexPath.row]?.amount,
            let buyingPrice = stocks[safe: indexPath.row]?.buyingPrice, let symbol = stocks[safe: indexPath.row]?.symbol {
            cell.stocknameLabel.text = name
            cell.dateBought.text = dateBought
            cell.amountOfStocks.text = String(amount)+" stocks"
            cell.boughtPrice.text = "price when bought: "+String(buyingPrice)+"$"
            
            api.getStockPriceNow(stocksymbol: symbol) { (result, statusCode) in
                print(result)
                DispatchQueue.main.async {
                    cell.priceNow.text = "price now: "+String(result)+"$"
                }
            }
        }
        return cell
    }

}
