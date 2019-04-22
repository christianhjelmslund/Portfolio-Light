//
//  MainViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 16/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit
import Charts

class MainViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var chartView: BubbleChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .myDark
        
        dataView.backgroundColor = .myLightPurple
        
        chartView.chartDescription?.enabled = false
        
        
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 40
        chartView.pinchZoomEnabled = true
        
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 18)!
        chartView.legend.textColor = .white
        chartView.legend.xEntrySpace = 7
        chartView.legend.yEntrySpace = 0
        chartView.legend.yOffset = 10
        chartView.legend.enabled = true
        
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        chartView.leftAxis.labelTextColor = .white
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelTextColor = .white
        
        chartView.rightAxis.labelTextColor = .white
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        chartView.drawGridBackgroundEnabled = false
        chartView.gridBackgroundColor = .clear
        
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        setData(range: 5)
    }
    
    
    func setData (range: UInt32) {
        
 
        let bcDataEntry2 = BubbleChartDataEntry(x: 1, y: 1, size: 30)
        let bcDataEntry3 = BubbleChartDataEntry(x: 3, y: 2, size: 30)
        let bcDataEntry4 = BubbleChartDataEntry(x: 4, y: 3, size: 30)
        let bcDataEntry5 = BubbleChartDataEntry(x: 1, y: 3, size: 30)
//        let bcDataEntry4 = BubbleChartDataEntry(x: 1, y: 1, size: 5)
//        let bcDataEntry5 = BubbleChartDataEntry(x: 4, y: 2, size: 2)
//
//
//        let yVals2 = (1..<5).map { (i) -> BubbleChartDataEntry in
//            let val = Double(arc4random_uniform(range))
//            let size = CGFloat(arc4random_uniform(range))
//            let chart = BubbleChartDataEntry(x: Double(i), y: val, size: size, icon: UIImage(named: "icon"))
//            return chart
//        }
        
        var myvalues: [BubbleChartDataEntry] = []
        myvalues.append(BubbleChartDataEntry(x: 0, y: 0, size: 0))
//        myvalues.append(bcDataEntry2)
        myvalues.append(bcDataEntry2)
        myvalues.append(bcDataEntry3)
        myvalues.append(bcDataEntry4)
        myvalues.append(bcDataEntry5)
        
        for value in myvalues {
            print(value)
        }
        
//        myvalues.append(bcDataEntry4)
        
//        let set1 = BubbleChartDataSet(values: yVals2, label: "DS 1")
//        set1.drawIconsEnabled = false
//        set1.setColor(ChartColorTemplates.colorful()[0], alpha: 0.5)
//        set1.drawValuesEnabled = true
//
        let mySet = BubbleChartDataSet(values: myvalues, label: "Boeing")
        mySet.setColor(.myGreen, alpha: 0.5)
        mySet.drawValuesEnabled = true

        let data = BubbleChartData(dataSets: [mySet])
        
        chartView.leftAxis.axisMinimum = 0
        chartView.xAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = 5
        chartView.xAxis.axisMaximum = 5
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        data.setValueFont(.systemFont(ofSize: 12, weight: .bold))
        
        data.setDrawValues(true)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 7)!)
        data.setHighlightCircleWidth(1.5)
        data.setValueTextColor(.white)
        
        chartView.data = data
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
