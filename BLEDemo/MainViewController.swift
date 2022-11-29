//
//  MainViewController.swift
//  CompassCompanion
//
//  Created by Rick Smith on 04/07/2016.
//  Copyright © 2016 Rick Smith. All rights reserved.
//

import UIKit
import CoreBluetooth


class MainViewController: UIViewController {
    private var timer: DispatchSourceTimer?
    @IBOutlet weak var currentPercentage: UILabel!
    @IBOutlet weak var batteryVC: UIView!
    @IBOutlet weak var temperatureVC: UIView!
    
    @IBOutlet weak var voltageLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var batteryLifeLabel: UILabel!
    
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var voltageBox: UIButton!
    
    @IBOutlet weak var tempBox1: UIButton!
    @IBOutlet weak var currentBox: UIButton!
    
    @IBOutlet weak var tempBox2: UIButton!
    var currentPercentageValue: Double = 0.0
    var voltageValue: Double = 0.0
    var currentValue: Double = 0.0
    var batteryLifeValue: Double = 0.0
    var powerValue: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBox.layer.cornerRadius = 10
        voltageBox.layer.cornerRadius = 10
        tempBox1.layer.cornerRadius = 10
        tempBox2.layer.cornerRadius = 10
        batteryVC.layer.cornerRadius = 10
        temperatureVC.layer.cornerRadius = 10
        self.startTimer()
        
    }
    
    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(10))
        timer!.setEventHandler { [weak self] in
            self?.getMostRecentBatteryData()
            DispatchQueue.main.async {
                // qos' default value is ´DispatchQoS.QoSClass.default`
                self?.updateAllDataLabels()
            }
        }
        timer!.resume()
    }

    @IBAction func switchViews (sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            batteryVC.alpha = 1
            temperatureVC.alpha = 0
        }else{
            batteryVC.alpha = 0
            temperatureVC.alpha = 1
        }
    }
    
    func updateHeader(newValue: String) {
        self.currentPercentage.text = newValue
    }
    
    func getMostRecentBatteryData() {
        BLEDemo.getMostRecentData(callback_func: self.updateAllData)
    }
    
    func updateAllDataLabels() {
        self.currentPercentage.text = String(format: "%.2f", self.currentPercentageValue) + "%"
        self.voltageLabel.text = String(format: "%.2f", self.voltageValue) + "V"
        self.currentLabel.text = String(format: "%.2f", self.currentValue) + "A"
        self.batteryLifeLabel.text = String(format: "%.2f", self.batteryLifeValue) + " min"
        self.powerLabel.text = String(format: "%.2f", self.powerValue) + "W"
    }
    
    func updateAllData(newDataDict: [String: Double]) {
        self.currentPercentageValue = newDataDict["current_percentage"] ?? 0.0
        self.voltageValue = newDataDict["total_voltage"] ?? 0.0
        self.currentValue = newDataDict["current"] ?? 0.0
        self.batteryLifeValue = newDataDict["battery_life"] ?? 0.0
        self.powerValue = newDataDict["power"] ?? 0.0
    }
}

