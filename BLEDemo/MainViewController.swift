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

    @IBOutlet weak var batteryVC: UIView!
    @IBOutlet weak var temperatureVC: UIView!
    
    @IBOutlet weak var voltageLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var temp2Label: UILabel!
    @IBOutlet weak var temp1Label: UILabel!
    
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
    
}

