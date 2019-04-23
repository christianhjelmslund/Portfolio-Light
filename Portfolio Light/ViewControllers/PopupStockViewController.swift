//
//  PopupStockViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 15/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class PopupStockViewController: UIViewController {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var illegalInputLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateBoughtLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountBoughtTextField: UITextField!
    @IBOutlet weak var amountBoughtLabel: UILabel!
    @IBOutlet weak var addStockButton: UIButton!
    @IBOutlet weak var cancelStockButton: UIButton!
    
    private var datePicker: UIDatePicker?
    let api = AlphaVantageAPI()
    var companyName = ""
    var companySymbol = ""
    let defaults = UserDefaults.standard
    var delegate: animateCompletionDelegate?
        
    @IBAction func cancelAction(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addStockAction(_ sender: Any) {
        illegalInputLabel.alpha = 0
        let tuple = validateDate(date: dateTextField.text!)
        let isValidated = tuple.0
        let date = tuple.1
        if !isValidated {
            UIView.animate(withDuration: 0.25, animations: {
                self.illegalInputLabel.alpha = 1
            })
        } else if validateAmount(amount: amountBoughtTextField.text!) == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.illegalInputLabel.alpha = 1
            })
            illegalInputLabel.text = "Please provide a valid amount of stocks bought"
        } else {
           
            guard let amount = Int(amountBoughtTextField.text!) else { return }
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            api.getStockPriceDate(stocksymbol: companySymbol, date: date) { price, statusCode in
                
                switch statusCode {
                    
                case .SUCCESS:
                    let stock = Stock(company: self.companyName, symbol: self.companySymbol, dateBought: date, buyingPrice: price, amount: amount)
                    print(self.companyName, self.companySymbol, date, price)
                    if let stocksData = self.defaults.object(forKey: "stocks") as? Data {
                        if var stocks = try? PropertyListDecoder().decode([Stock].self, from: stocksData) {
                            stocks.append(stock)
                            self.defaults.removeObject(forKey: "stocks")
                            self.defaults.set(try? PropertyListEncoder().encode(stocks), forKey: "stocks")
                        }
                    } else {
                        var stocks: [Stock] = []
                        stocks.append(stock)
                        self.defaults.set(try? PropertyListEncoder().encode(stocks), forKey: "stocks")
                    }
                    self.delegate?.animateCompletion()
                    self.dismiss(animated: true, completion: nil)
                    
                 case .FAILURE:
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.illegalInputLabel.alpha = 1
                        })
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.illegalInputLabel.text = "Are you sure the stock was traded that day?"
                    }
                }
            }
        }
    }

    func validateDate(date: String) -> (Bool, String) {
      
        let dateFormatterOne = DateFormatter()
        dateFormatterOne.dateFormat = "dd.MM.yy"
        let chosenDateTime = dateFormatterOne.date(from: date)
        let currentDateTime = Date()
        
        if let chosenDateTime = chosenDateTime {
            if chosenDateTime >= currentDateTime {
                UIView.animate(withDuration: 0.25, animations: {
                    self.illegalInputLabel.alpha = 1
                })
                illegalInputLabel.text = "You cannot pick a future date"
                return (false, "")
            }
        }
        if (chosenDateTime != nil)  {
            let day = date[NSRange(location: 0, length: 2)]
            let month = date[NSRange(location: 3, length: 2)]
            let year = date[NSRange(location: 6, length: 4)]
            print(day, month, year)
            let formattedDate = String(year+"-"+month+"-"+day)
            print(formattedDate)
            return (true, formattedDate)
        } else {
            illegalInputLabel.text = "The date did not match the expected format"
            return (false, "")
        }
    }
    func validateAmount(amount: String) -> Int {
        if !amount.isEmpty {
            if let integerAmount = Int(amount) {
                if integerAmount > 0 {
                    return integerAmount
                }
            }
        }
        return 0
    }

    @objc func dismissKeyboard(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        activityIndicator.isHidden = true
        activityIndicator.style = .whiteLarge
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        amountBoughtTextField.keyboardType = UIKeyboardType.numberPad
        titleLabel.text = companyName
        titleLabel.textColor = .myPurple
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        dateBoughtLabel.textColor = .myLightPurple
        dateBoughtLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateBoughtLabel.adjustsFontForContentSizeCategory = true
        
        dateTextField.backgroundColor = .myDarkGray
        dateTextField.textColor = .myPurple
        
        illegalInputLabel.textColor = .errorColor
        amountBoughtTextField.backgroundColor = .myDarkGray
        amountBoughtTextField.textColor = .myPurple
        
        amountBoughtLabel.textColor = .myLightPurple
        amountBoughtLabel.font = UIFont.preferredFont(forTextStyle: .body)
        amountBoughtLabel.adjustsFontForContentSizeCategory = true
        
        addStockButton.setTitleColor(.myPurple, for: .normal)
        addStockButton.backgroundColor = .clear
        addStockButton.layer.cornerRadius = 15
        addStockButton.layer.borderWidth = 2
        addStockButton.layer.borderColor = .myPurple
        
        cancelStockButton.setTitleColor(.myPurple, for: .normal)
        cancelStockButton.backgroundColor = .clear
        cancelStockButton.layer.cornerRadius = 15
        cancelStockButton.layer.borderWidth = 2
        cancelStockButton.layer.borderColor = .myPurple
        
        backgroundView.layer.cornerRadius = 15
        backgroundView.layer.shadowColor = .myLightPurple
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 15
        backgroundView.backgroundColor = .myDark
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


