//
//  apiMiddleware'.swift
//  BLEDemo
//
//  Created by Thomas Mactaggart on 11/1/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import Foundation

let urlBase = "http://10.110.65.50:5000/"
var sessionID = ""
var userID = ""

// Send the cache data to the backend
func sendData(totVoltageCache: [Dictionary<String, String>],
              voltageOneCache: [Dictionary<String, String>],
              voltageTwoCache: [Dictionary<String, String>],
              currentCache: [Dictionary<String, String>],
              temperatureOneCache: [Dictionary<String, String>],
              temperatureTwoCache: [Dictionary<String, String>]) {
    let config = URLSessionConfiguration.default

    let session = URLSession(configuration: config)

    let url = URL(string: urlBase + "loadRawData")
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"

    let postDict : [String: Any] = ["totalVoltage": totVoltageCache,
                                    "voltageOne": voltageOneCache,
                                    "votlageTwo": voltageTwoCache,
                                    "current": currentCache,
                                    "temperatureOne": temperatureOneCache,
                                    "temperatureTwo": temperatureTwoCache,
                                    "sessionID": sessionID,
                                    "userID": userID]

    print("Sending data to the backend...")
    guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
        return
    }
    urlRequest.httpBody = postData

    let task = session.dataTask(with: urlRequest) { data, response, error in
        guard let data = data else { return }
        print(data)
        let trimmedString = String(data: data, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
        sessionID = trimmedString;
    }

    task.resume()
}


// Get the current temperature, max session temperature, and min session temperature from the backend
func getTemperatureData(callback_func: @escaping (_: String, _: String, _: String) -> ()) {
    if (sessionID == "") {
        // TODO: return here once working with phone again
        sessionID = "1"
    }
    let url = URL(string: urlBase + "temperature?sessionID=" + sessionID)
    
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    request.setValue(sessionID, forHTTPHeaderField: "SessionID")
    // Send HTTP Request
    print("Getting temperature from the backend...")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Convert HTTP Response Data to a simple String
        var dataDict = ["current_temp": 100.0, "min_ride_temp": 0.0, "max_ride_temp": 200.0]
        do {
            dataDict = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Double])!;
        } catch {
            print("Unable to convert to dictionary")
        }
        if (dataDict["min_ride_temp"] != nil && dataDict["max_ride_temp"] != nil && dataDict["current_temp"] != nil) {
            callback_func(String(dataDict["min_ride_temp"]!), String(dataDict["current_temp"]!), String(dataDict["max_ride_temp"]!))
        }
//        if let data = data, let dataString = String(data: data, encoding: .utf8) {
//            let dataDict = convertToDictionary(text: dataString);
//
//        }
        
    }
    task.resume()

}


// Method to validate a login attempt
func isValidLogin(username: String, password: String, callback_func: @escaping (_: Bool) -> ()) {
    let config = URLSessionConfiguration.default

    let session = URLSession(configuration: config)

    let url = URL(string: urlBase + "login")
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"

    let postDict : [String: Any] = ["username": username, "password": password]

    print("Trying to login " + username + "...")
    guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
        return
    }
    urlRequest.httpBody = postData
    

    let task = session.dataTask(with: urlRequest) { data, response, error in
        guard let data = data else { return }
        let trimmedString = String(data: data, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
        if trimmedString == "-1" {
            callback_func(false)
        }
        else {
            callback_func(true)
            userID = trimmedString;
        }
    }

    task.resume()
}


// Method to create an account
func createAccount(username: String, password: String, firstName: String, lastName: String, callback_func: @escaping (_: Bool) -> ()) {
    let config = URLSessionConfiguration.default

    let session = URLSession(configuration: config)

    let url = URL(string: urlBase + "createAccount")
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"

    let postDict : [String: Any] = ["username": username, "password": password, "first_name": firstName, "last_name": lastName]

    print("Creating an account for " + username + "...")
    guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
        return
    }
    urlRequest.httpBody = postData
    

    let task = session.dataTask(with: urlRequest) { data, response, error in
        guard let data = data else { return }
        let trimmedString = String(data: data, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
        if trimmedString == "-1" {
            callback_func(false)
        }
        else {
            callback_func(true)
            userID = trimmedString;
        }
    }

    task.resume()
}
