//
//  TemperatureViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 11/1/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {

    @IBOutlet weak var tCircle: UIView!
    @IBOutlet weak var tCircle2: UIView!
    
    @IBOutlet weak var tTop: UIView!
    @IBOutlet weak var tTop2: UIView!
    @IBOutlet weak var lowNum: UILabel!
    @IBOutlet weak var highNum: UILabel!
    
    @IBOutlet weak var marker: UIView!
    
    @IBOutlet weak var marker2: UIView!
    
    @IBOutlet weak var highNum2: UILabel!
    @IBOutlet weak var lowNum2: UILabel!
    
    @IBOutlet weak var currNum2: UILabel!
    
    @IBOutlet weak var currNum: UILabel!
    private var timer: DispatchSourceTimer?
    var lowTemp1: String = ""
    var lowTemp2: String = ""
    var currentTemp1: String = ""
    var currentTemp2: String = ""
    var highTemp1: String = ""
    var highTemp2: String = ""
   
    var minWidth: Int = 10
    var maxWidth: Int = 110
    var barHeight: Int = 40
    
    var barStartX: Int = 122
    var barStartY: Int = 41
    var bar2StartX: Int = 122
    var bar2StartY: Int = 131
    
    var barWidth: Int = 0
    var barWidth2: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tCircle.layer.cornerRadius = tCircle.frame.height / 2
        tCircle.clipsToBounds = true
        
        tTop.layer.cornerRadius = tTop.frame.height / 3
        tTop.clipsToBounds = true
        
        tCircle2.layer.cornerRadius = tCircle2.frame.height / 2
        tCircle2.clipsToBounds = true
        
        tTop2.layer.cornerRadius = tTop2.frame.height / 3
        tTop2.clipsToBounds = true
        setSize1(low: "100", current: "180", high: "200")
        setSize2(low: "100", current: "100", high: "200")
        startTimer()
    }
    
    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(10))
        timer!.setEventHandler { [weak self] in

            self?.getTempData();
            DispatchQueue.main.async {
                // qos' default value is ´DispatchQoS.QoSClass.default`
                self?.setSize1(low: self?.lowTemp1 ?? "50", current: self?.currentTemp1 ?? "100", high: self?.highTemp1 ?? "200")
                self?.setSize2(low: self?.lowTemp2 ?? "50", current: self?.currentTemp2 ?? "100", high: self?.highTemp2 ?? "200")
            }
        }
        timer!.resume()
    }
    
    func useTempData(lowest: String, current: String, highest: String) {
        lowTemp1 = lowest
        currentTemp1 = current
        highTemp1 = highest
    }
    
    func useTempData2(lowest: String, current: String, highest: String) {
        lowTemp2 = lowest
        currentTemp2 = current
        highTemp2 = highest
    }
    
    func getTempData() {
        BLEDemo.getTemperatureData(callback_func: useTempData, callback_func_2: useTempData2);
    }
    
    func setSize1(low: String, current: String, high: String){
        //set labels
        highNum.text = high
        lowNum.text = low
        currNum.text = current
        
        let currValue = Double(current) ?? 0
        let maxValue = Double(high) ?? 0
        let minValue = Double(low) ?? 0
        let maxDiff = maxValue - minValue
        let tickSize = maxDiff / 100.0
        
        if (currValue == maxValue){
            barWidth = maxWidth
        }else{
            let actualDiff = currValue - minValue
            let numTicks = actualDiff / tickSize
            barWidth = Int(numTicks) + minWidth
        }

        marker.frame =  CGRect(x:barStartX, y: barStartY, width:barWidth, height: barHeight)
    }
    
    func setSize2(low: String, current: String, high: String){
        highNum2.text = high
        lowNum2.text = low
        currNum2.text = current

        let currValue2 = Double(current) ?? 0
        let maxValue2 = Double(high) ?? 0
        let minValue2 = Double(low) ?? 0
        let maxDiff = maxValue2 - minValue2
        let tickSize = maxDiff / 100.0
        
        if (currValue2 == maxValue2){
            barWidth2 = maxWidth
        }else{
            let actualDiff = currValue2 - minValue2
            let numTicks = actualDiff / tickSize
            barWidth2 = Int(numTicks) + minWidth
        }

        marker2.frame =  CGRect(x:bar2StartX, y: bar2StartY, width:barWidth2, height: barHeight)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
