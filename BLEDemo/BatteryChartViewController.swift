//
//  BatteryChartViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 11/1/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints
class BatteryChartViewController: UIViewController {

    lazy var lineChartView: LineChartView = {
        let frame = CGRect(x: 0, y: 0, width: 340, height: 215)
        let chartView = LineChartView(frame: frame)
        //let chartView = LineChartView()
        chartView.backgroundColor = .lightGray
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 8)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .insideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 8)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        return chartView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(lineChartView)
        
        setData()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        print(entry)
    }
    func setData(){
        
        let set1 = LineChartDataSet(entries: yValues, label: "Battery Percentage")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.white)
        //set1.fill = Fill(color: .white)
        set1.fillAlpha = 0.8
        set1.highlightColor = .systemRed
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
        
    }
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x:0.0, y:10.0),
        ChartDataEntry(x:1, y:11.0),
        ChartDataEntry(x:2, y:12.0),
        ChartDataEntry(x:3, y:12.5),
        ChartDataEntry(x:4, y:13.0),
        ChartDataEntry(x:5, y:14.0)
    ]
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
