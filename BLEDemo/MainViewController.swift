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
//    let BLEService = "DFB0"
//    let BLECharacteristic = "DFB1"
//    let battery1ID = "Battery1 Voltage"
//    let battery2ID = "Battery 2 Voltage"
//    let totalVoltageID = "Total Voltage"
//    let currentID = "Current"
//    let temperatureID = "Temperature(C)"
//    var totVoltageCache: [Dictionary<String, String>] = []
//    var voltageOneCache: [Dictionary<String, String>] = []
//    var voltageTwoCache: [Dictionary<String, String>] = []
//    var currentCache: [Dictionary<String, String>] = []
//    var temperatureCache: [Dictionary<String, String>] = []
//    let urlBase = "http://10.110.159.186:5000/"
//    var sessionID = ""
//
//    @IBOutlet weak var recievedMessageText: UILabel!
//    var nextMessageText: String = "";
//
//    private var timer: DispatchSourceTimer?
//
//    // Start the 10 second time for the next data send task and clear out all caches
//    func startTimer() {
//        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
//        timer = DispatchSource.makeTimerSource(queue: queue)
//        timer!.schedule(deadline: .now(), repeating: .seconds(10))
//        timer!.setEventHandler { [weak self] in
//
//            self?.sendData()
//
//            DispatchQueue.main.async {
//                self?.resetCaches();
//            }
//        }
//        timer!.resume()
//    }
//
//    // Clear out all caches
//    func resetCaches() {
//        totVoltageCache = []
//        voltageOneCache = []
//        voltageTwoCache = []
//        currentCache = []
//        temperatureCache = []
//    }
//
//    // Stop the timer (stop sending data)
//    func stopTimer() {
//        timer?.cancel()
//        timer = nil
//    }
//
//    // Send the cache data to the backend
//    func sendData() {
//        let config = URLSessionConfiguration.default
//
//        let session = URLSession(configuration: config)
//
//        let url = URL(string: urlBase + "loadRawData")
//        var urlRequest = URLRequest(url: url!)
//        urlRequest.httpMethod = "POST"
//
//        let postDict : [String: Any] = ["totalVoltage": totVoltageCache,
//                                        "voltageOne": voltageOneCache,
//                                        "votlageTwo": voltageTwoCache,
//                                        "current": currentCache,
//                                        "temperature": temperatureCache,
//                                        "sessionID": sessionID]
//
//        print("Sending Data to the Backend...")
//        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
//            return
//        }
//        urlRequest.httpBody = postData
//
//        let task = session.dataTask(with: urlRequest) { data, response, error in
//            guard let data = data else { return }
//            let trimmedString = String(data: data, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
//            self.sessionID = trimmedString
//        }
//
//        task.resume()
//    }
//
//    // Cache and sort the raw data from the BLE device and add the current timestamp
//    func cacheData(dataString: String) throws {
//        let splitString = dataString.split(separator: ":")
//        let type = splitString[0]
//        let data = splitString[1]
//        let timestamp = NSDate().timeIntervalSince1970
//        switch type {
//        case battery1ID:
//            voltageOneCache.append(["value": String(data), "timestamp": String(timestamp)]);
//            break;
//        case battery2ID:
//            voltageTwoCache.append(["value": String(data), "timestamp": String(timestamp)]);
//            break;
//        case totalVoltageID:
//            totVoltageCache.append(["value": String(data), "timestamp": String(timestamp)]);
//            break;
//        case currentID:
//            currentCache.append(["value": String(data), "timestamp": String(timestamp)]);
//            break;
//        case temperatureID:
//            temperatureCache.append(["value": String(data), "timestamp": String(timestamp)]);
//            break;
//        default:
//            throw NSError();
//        }
//    }


    @IBOutlet weak var chartBorder: UIImageView!
    
    @IBOutlet weak var currentBox: UIImageView!
    
    @IBOutlet weak var voltageBox: UIImageView!
    
    @IBOutlet weak var tempBox2: UIImageView!
    
    @IBOutlet weak var tempBox1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartBorder.layer.masksToBounds = true
        chartBorder.layer.cornerRadius = chartBorder.frame.height / 8
        
        currentBox.layer.cornerRadius = currentBox.frame.height / 8

        voltageBox.layer.cornerRadius = voltageBox.frame.height / 8
        
        tempBox1.layer.cornerRadius = tempBox1.frame.height / 8
        
        tempBox2.layer.cornerRadius = tempBox2.frame.height / 8
        
        
    }
    
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if (segue.identifier == "scan-segue") {
//            let scanController : ScanTableViewController = segue.destination as! ScanTableViewController
//
//            //set the manager's delegate to the scan view so it can call relevant connection methods
//            manager?.delegate = scanController
//            scanController.manager = manager
//            scanController.parentView = self
//        }
//
//    }
}

