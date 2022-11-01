//
//  apiMiddleware'.swift
//  BLEDemo
//
//  Created by Thomas Mactaggart on 11/1/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import Foundation

let urlBase = "http://10.110.77.11:5000/"
var sessionID = ""

// Send the cache data to the backend
func sendData(totVoltageCache: [Dictionary<String, String>],
              voltageOneCache: [Dictionary<String, String>],
              voltageTwoCache: [Dictionary<String, String>],
              currentCache: [Dictionary<String, String>],
              temperatureCache: [Dictionary<String, String>]) {
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
        sessionID = trimmedString;
    }

    task.resume()
}


// Get the current temperature, max session temperature, and min session temperature from the backend
func getTemperatureData() {
    if (sessionID == "") {
        return
    }
    let url = URL(string: urlBase + "temperature?sessionID=" + sessionID)
    
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    request.setValue(sessionID, forHTTPHeaderField: "SessionID")
    // Send HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Convert HTTP Response Data to a simple String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }
        
    }
    task.resume()

}
