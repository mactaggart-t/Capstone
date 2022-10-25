//
//  MainViewController.swift
//  CompassCompanion
//
//  Created by Rick Smith on 04/07/2016.
//  Copyright © 2016 Rick Smith. All rights reserved.
//

import UIKit
import CoreBluetooth


class MainViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager? = nil
    var mainPeripheral:CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    
    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"
    let battery1ID = "Battery1 Voltage"
    let battery2ID = "Battery 2 Voltage"
    let totalVoltageID = "Total Voltage"
    let currentID = "Current"
    let temperatureID = "Temperature(C)"
    var totVoltageCache: [Dictionary<String, String>] = []
    var voltageOneCache: [Dictionary<String, String>] = []
    var voltageTwoCache: [Dictionary<String, String>] = []
    var currentCache: [Dictionary<String, String>] = []
    var temperatureCache: [Dictionary<String, String>] = []
    let urlBase = "http://10.110.159.186:5000/"
    var sessionID = ""
    
    @IBOutlet weak var recievedMessageText: UILabel!
    var nextMessageText: String = "";
    
    private var timer: DispatchSourceTimer?

    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(10))
        timer!.setEventHandler { [weak self] in

            self?.sendData()

            DispatchQueue.main.async {
                self?.resetCaches();
            }
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
    }

    // Stop the timer (stop sending data)
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    // Send the cache data to the backend
    func sendData() {
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)

        let url = URL(string: urlBase + "loadRawData")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        let postDict : [String: Any] = ["totalVoltage": totVoltageCache,
                                        "voltageOne": voltageOneCache,
                                        "votlageTwo": voltageTwoCache,
                                        "current": currentCache,
                                        "temperature": temperatureCache,
                                        "sessionID": sessionID]

        print("Sending Data to the Backend...")
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            let trimmedString = String(data: data, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
            self.sessionID = trimmedString
        }

        task.resume()
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
        default:
            throw NSError();
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CBCentralManager(delegate: self, queue: nil);
        
        customiseNavigationBar()
        
    }
    
    func customiseNavigationBar () {
        
        self.navigationItem.rightBarButtonItem = nil
        
        let rightButton = UIButton()
        
        if (mainPeripheral == nil) {
            rightButton.setTitle("Scan", for: [])
            rightButton.setTitleColor(UIColor.blue, for: [])
            rightButton.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 60, height: 30))
            rightButton.addTarget(self, action: #selector(self.scanButtonPressed), for: .touchUpInside)
        } else {
            rightButton.setTitle("Disconnect", for: [])
            rightButton.setTitleColor(UIColor.blue, for: [])
            rightButton.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 30))
            rightButton.addTarget(self, action: #selector(self.disconnectButtonPressed), for: .touchUpInside)
        }
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "scan-segue") {
            let scanController : ScanTableViewController = segue.destination as! ScanTableViewController
            
            //set the manager's delegate to the scan view so it can call relevant connection methods
            manager?.delegate = scanController
            scanController.manager = manager
            scanController.parentView = self
        }
        
    }
    
    // MARK: Button Methods
    @objc func scanButtonPressed() {
        performSegue(withIdentifier: "scan-segue", sender: nil)
    }
    
    @objc func disconnectButtonPressed() {
        //this will call didDisconnectPeripheral, but if any other apps are using the device it will not immediately disconnect
        manager?.cancelPeripheralConnection(mainPeripheral!)
    }
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        let helloWorld = "Hello World!"
        let dataToSend = helloWorld.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
            mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        } else {
            print("haven't discovered device yet")
        }
    }
    
    // MARK: - CBCentralManagerDelegate Methods    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        mainPeripheral = nil
        customiseNavigationBar()
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
                        recievedMessageText.text = tempStr;
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

