//
//  FourthViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 15/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class AddStockController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, animateCompletionDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var animationViewLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    private let api = AlphaVantageAPI()
    private var keywords: [StockSearchResult] = []
    
    @IBAction func doneAction(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        mainVC.modalTransitionStyle = .crossDissolve
        present(mainVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.view.setGradientBackground()
        
        doneButton.backgroundColor = .myDark
        doneButton.layer.cornerRadius = 15
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = .myPurple
        doneButton.setTitleColor(.myPurple, for: .normal)
        animationViewLabel.textColor = .myGreen
        animationViewLabel.frame = animationView.bounds
        searchBar.barTintColor = .myDark
        searchBar.barStyle = .black
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    func animateCompletion(){
        DispatchQueue.main.async {
            self.animationView.isHidden = false
            self.animationViewLabel.alpha = 1
            let shape = CAShapeLayer()
            self.animationViewLabel.text = "adding..."
            self.animationView.layer.addSublayer(shape)
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = .myGreen
            shape.lineCap = CAShapeLayerLineCap.round
            shape.strokeEnd = 0
            shape.lineWidth = 10
            
            let path = CGMutablePath()
            path.addEllipse(in: self.animationView.layer.bounds)
            shape.path = path
            
            let animcolor = CABasicAnimation(keyPath: "strokeEnd")
            animcolor.toValue = 1
            animcolor.duration = 0.5
            animcolor.isRemovedOnCompletion = false
            shape.add(animcolor, forKey: "strokeEnd")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animationViewLabel.text = "success!"
                UIView.animate(withDuration: 2, animations: {
                    self.animationViewLabel.alpha = 0
                })
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                 self.animationView.isHidden = true
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            api.getSearchValues(keyword: searchText) { result, status in
                
                if result.isEmpty {
                    self.keywords.removeAll()
                } else {
                    self.keywords = result
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            keywords.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            api.getSearchValues(keyword: text) { result, status in
                print(result)
                if result.isEmpty {
                    self.keywords.removeAll()
                } else {
                    self.keywords.removeAll()
                    self.keywords = result
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
           
        }
        self.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if keywords.count == 0 {
            tableView.setEmptyView(title: "Search for assets above!", message: "Results will be shown here")
        }
        else {
            tableView.restore()
        }
        return keywords.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! SearchResultCell
        
        if let name = keywords[safe: indexPath.row]?.name, let symbol = keywords[safe: indexPath.row]?.symbol, let region = keywords[safe: indexPath.row]?.region {
            cell.companyNameLabel.text = name
            cell.companySymbolLabel.text = symbol
            cell.regionLabel.text = region
            cell.regionLabel.textColor = .myLightPurple
            cell.companySymbolLabel.textColor = .myLightPurple
            cell.companyNameLabel.textColor = .myPurple
        } else {
            tableView.setEmptyView(title: "An error occured!", message: "Please try again later")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupVC = storyboard?.instantiateViewController(withIdentifier: "PopupStock") as! PopupStockViewController
        popupVC.delegate = self
        popupVC.companyName = keywords[indexPath.row].name
        popupVC.companySymbol = keywords[indexPath.row].symbol
        present(popupVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .myPurple
        titleLabel.font = UIFont(name: "SF-Compact-Text-Regular", size: 26)
        messageLabel.textColor = .myGray
        messageLabel.font = UIFont(name: "SF-Compact-Text-Regular", size: 22)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none

    }
}

protocol animateCompletionDelegate {
    func animateCompletion()
}

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
