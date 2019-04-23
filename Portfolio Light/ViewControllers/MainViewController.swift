//
//  MainViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 23/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit
import SwiftReorder

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var spaceBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomInfoBar: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    private let refreshControl = UIRefreshControl()
    private let defaults = UserDefaults.standard
    private let api = AlphaVantageAPI()
    private var stocks: [Stock] = []
    
    @IBAction func addStock(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "addStockVC")
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        switch tableView.isEditing {
        case true:
            editButton.title = "done"
        case false:
            editButton.title = "edit"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getStocks()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = .myPurple
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Stock Data...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.myPurple])
      

        self.view.setGradientBackground()
        topViewBar.backgroundColor = .myPurple
        navigationBar.barTintColor = .myPurple
        tableView.separatorStyle = .none
        navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.myDark]
        navigationBar.titleTextAttributes = textAttributes
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            stocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let stock = stocks[sourceIndexPath.row]
        stocks.remove(at: sourceIndexPath.row)
        stocks.insert(stock, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainViewCell") as! MainViewCell
        
        
        if let stock = stocks[safe: indexPath.row] {
            cell.stocknameLabel.text = stock.company
            cell.dateBought.text = stock.dateBought
            cell.amountOfStocks.text = String(stock.amount)+" stocks"
            cell.boughtPrice.text = "price when bought: "+String(stock.buyingPrice)+"$"
            
            api.getStockPriceNow(stocksymbol: stock.symbol) { (result, statusCode) in
                switch statusCode {
                case .SUCCESS:
                    DispatchQueue.main.async {
                        cell.priceNow.text = "price now: "+String(result)+"$"
                        let values: (percentage: Int, rawValue: Int) = stock.calculateLossOrProfit(priceNow: result)
                        if values.rawValue > 0 {
                            cell.percentageLabel.textColor = .myDarkGreen
                            cell.rawValueLabel.textColor = .myDarkGreen
                            cell.profitView.backgroundColor = .myGreen
                            cell.percentageLabel.text = "+\(String(values.percentage))%"
                            cell.rawValueLabel.text = "+\(String(values.rawValue))$"
                        } else {
                            cell.percentageLabel.textColor = .myDarkRed
                            cell.rawValueLabel.textColor = .myDarkRed
                            cell.profitView.backgroundColor = .myRed
                            cell.percentageLabel.text = "\(String(values.percentage))%"
                            cell.rawValueLabel.text = "\(String(values.rawValue))$"
                        }
                        self.refreshControl.endRefreshing()
                    }
                case .FAILURE:
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
        return cell
    }
}
