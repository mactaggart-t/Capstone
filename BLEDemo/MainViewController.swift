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

    @IBOutlet weak var currentBox: UIImageView!
    @IBOutlet weak var voltageBox: UIImageView!
    @IBOutlet weak var tempBox2: UIImageView!
    @IBOutlet weak var tempBox1: UIImageView!
    @IBOutlet weak var batteryVC: UIView!
    @IBOutlet weak var temperatureVC: UIView!
    
    @IBOutlet weak var voltageLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var temp2Label: UILabel!
    @IBOutlet weak var temp1Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBox.layer.cornerRadius = currentBox.frame.height / 8
        voltageBox.layer.cornerRadius = voltageBox.frame.height / 8
        tempBox1.layer.cornerRadius = tempBox1.frame.height / 8
        tempBox2.layer.cornerRadius = tempBox2.frame.height / 8
        batteryVC.layer.cornerRadius = 10
        temperatureVC.layer.cornerRadius = 10
        
        startTimer();
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
    
    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(10))
        timer!.setEventHandler { [weak self] in

            self?.getTempData();
        }
        timer!.resume()
    }
    
    func getTempData() {
        BLEDemo.getTemperatureData();
    }
}

