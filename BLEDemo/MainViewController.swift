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
        BLEDemo.getMostRecentData(callback_func: self.updateAllDataLabels)
    }
    
    func updateAllDataLabels(newDataDict: [String: Double]) {
        print(newDataDict)
        self.currentPercentage.text = String(format: "%.2f", newDataDict["current_percentage"]!) + "%"
        self.voltageLabel.text = String(format: "%.2f", newDataDict["total_voltage"]!) + "V"
        self.currentLabel.text = String(format: "%.2f", newDataDict["current"]!) + "A"
        self.batteryLifeLabel.text = String(format: "%.2f", newDataDict["battery_life"]!) + " min"
        self.powerLabel.text = String(format: "%.2f", newDataDict["power"]!) + "W"
    }
}

