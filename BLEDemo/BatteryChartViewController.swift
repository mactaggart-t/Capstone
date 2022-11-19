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
    private var timer: DispatchSourceTimer?
    var yValues: [ChartDataEntry] = []
    
    lazy var lineChartView: LineChartView = {
        let frame = CGRect(x: 0, y: 0, width: 323, height: 200)
        let chartView = LineChartView(frame: frame)
        //let chartView = LineChartView()
        chartView.backgroundColor = .systemGray5
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 8)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.setLabelCount(6, force: false)
        
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
        
        let label = UILabel(frame: CGRect(x: 135, y: 202, width: 60, height: 10))
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.text = "Time(mins)"
        
        view.addSubview(lineChartView)
        view.addSubview(label)
        
        setData()
        startTimer()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues, label: "Battery Percentage")
        set1.mode = .cubicBezier
        
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(.white)
        set1.fill = ColorFill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
        
    }
    
    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(10))
        timer!.setEventHandler { [weak self] in
            self?.getBatteryPercentagesAndUpdateChart()
        }
        timer!.resume()
    }
    
    func getBatteryPercentagesAndUpdateChart() {
        BLEDemo.getBatteryPercentages(callback_func: self.updateChart)
    }
    
    func updateChart(xyPairs: [[Double]]) {
        var tempYValues: [ChartDataEntry] = []
        for pair in xyPairs {
            if (pair.count != 2) {
                print("Error parsing data: incorrect size, pairs must have two members")
                return
            }
            tempYValues.append(ChartDataEntry(x: pair[1], y: pair[0]))
        }
        yValues = tempYValues
        self.setData()
    }
    

}
