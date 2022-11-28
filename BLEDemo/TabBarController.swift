//
//  MainViewController.swift
//  CompassCompanion
//
//  Created by Rick Smith on 04/07/2016.
//  Copyright © 2016 Rick Smith. All rights reserved.
//

import UIKit
import CoreBluetooth


class TabBarController: UITabBarController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager? = nil
    var mainPeripheral:CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    
    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"
    let battery1ID = "Battery 1 Voltage"
    let battery2ID = "Battery 2 Voltage"
    let totalVoltageID = "Total Voltage"
    let currentID = "Current"
    let temperatureID = "Battery 1 Temperature(C)"
    let temperatureTwoID = "Battery 2 Temperature(C)"
    var totVoltageCache: [Dictionary<String, String>] = []
    var voltageOneCache: [Dictionary<String, String>] = []
    var voltageTwoCache: [Dictionary<String, String>] = []
    var currentCache: [Dictionary<String, String>] = []
    var temperatureCache: [Dictionary<String, String>] = []
    var temperatureTwoCache: [Dictionary<String, String>] = []
    var nextMessageText: String = "";
    private var timer: DispatchSourceTimer?
    
    override var selectedViewController: UIViewController? {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    
    func tabChangedTo(selectedIndex: Int) {
        if selectedIndex == 1 {
            let scanController : ScanTableViewController = self.selectedViewController as! ScanTableViewController
            
            //set the manager's delegate to the scan view so it can call relevant connection methods
            manager?.delegate = scanController
            scanController.manager = manager
            scanController.parentView = self
        }
    }

    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(10))
        timer!.setEventHandler { [weak self] in

            self?.sendData()
            
        }
        timer!.resume()
    }
    
    // Clear out all caches
    func resetCaches() {
        totVoltageCache = []
        voltageOneCache = []
        voltageTwoCache = []
        currentCache = []
        temperatureCache = []
        temperatureTwoCache = []
    }

    // Stop the timer (stop sending data)
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    // Send the cache data to the backend
    func sendData() {
        BLEDemo.sendData(totVoltageCache: totVoltageCache,
                                     voltageOneCache: voltageOneCache,
                                     voltageTwoCache: voltageTwoCache,
                                     currentCache: currentCache,
                                     temperatureOneCache: temperatureCache,
                                     temperatureTwoCache: temperatureTwoCache)
        self.resetCaches()
    }
    
    // Cache and sort the raw data from the BLE device and add the current timestamp
    func cacheData(dataString: String) throws {
        let splitString = dataString.split(separator: ":")
        let type = splitString[0]
        let data = splitString[1]
        let timestamp = NSDate().timeIntervalSince1970
        switch type {
        case battery1ID:
            voltageOneCache.append(["value": String(data), "timestamp": String(timestamp)]);
            break;
        case battery2ID:
            voltageTwoCache.append(["value": String(data), "timestamp": String(timestamp)]);
            break;
        case totalVoltageID:
            totVoltageCache.append(["value": String(data), "timestamp": String(timestamp)]);
            break;
        case currentID:
            currentCache.append(["value": String(data), "timestamp": String(timestamp)]);
            break;
        case temperatureID:
            temperatureCache.append(["value": String(data), "timestamp": String(timestamp)]);
            break;
        case temperatureTwoID:
            temperatureTwoCache.append(["value": String(data), "timestamp": String(timestamp)]);
            break;
        default:
            throw NSError();
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        manager = CBCentralManager(delegate: self, queue: nil);
    }
    
    @objc func disconnectButtonPressed() {
        //this will call didDisconnectPeripheral, but if any other apps are using the device it will not immediately disconnect
        manager?.cancelPeripheralConnection(mainPeripheral!)
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        mainPeripheral = nil
        stopTimer()
        print("Disconnected" + peripheral.name!)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    
    // MARK: CBPeripheralDelegate Methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            print("Service found with UUID: " + service.uuid.uuidString)
            
            //device information service
            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //GAP (Generic Access Profile) for Device Name
            // This replaces the deprecated CBUUIDGenericAccessProfileString
            if (service.uuid.uuidString == "1800") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //Bluno Service
            if (service.uuid.uuidString == BLEService) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        //get device name
        if (service.uuid.uuidString == "1800") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A00") {
                    peripheral.readValue(for: characteristic)
                    print("Found Device Name Characteristic")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "180A") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A29") {
                    peripheral.readValue(for: characteristic)
                    print("Found a Device Manufacturer Name Characteristic")
                } else if (characteristic.uuid.uuidString == "2A23") {
                    peripheral.readValue(for: characteristic)
                    print("Found System ID")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == BLEService) {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == BLECharacteristic) {
                    //we'll save the reference, we need it to write data
                    mainCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Found Bluno Data Characteristic")
                    startTimer()
                }
                
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        if (characteristic.uuid.uuidString == "2A00") {
            //value for device name recieved
            let deviceName = characteristic.value
            print(deviceName ?? "No Device Name")
        } else if (characteristic.uuid.uuidString == "2A29") {
            //value for manufacturer name recieved
            let manufacturerName = characteristic.value
            print(manufacturerName ?? "No Manufacturer Name")
        } else if (characteristic.uuid.uuidString == "2A23") {
            //value for system ID recieved
            let systemID = characteristic.value
            print(systemID ?? "No System ID")
        } else if (characteristic.uuid.uuidString == BLECharacteristic) {
            //data recieved
            if(characteristic.value != nil) {
                let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)
                if (stringValue != nil) {
                    if (nextMessageText.hasSuffix("eos")) {
                        nextMessageText = ""
                    }
                    nextMessageText = nextMessageText + stringValue!;
                    if (nextMessageText.hasSuffix("eos")) {
                        var tempStr = nextMessageText
                        tempStr.removeLast(3)
                        do {
                            try cacheData(dataString: tempStr);
                        }
                        catch _ as NSError {
                            print("Error: Could Not Cache Data");
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
}

