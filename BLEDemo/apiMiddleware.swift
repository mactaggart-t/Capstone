//
//  apiMiddleware'.swift
//  BLEDemo
//
//  Created by Thomas Mactaggart on 11/1/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import Foundation

let urlBase = "http://10.110.194.111:5000/"
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
                                    "voltageTwo": voltageTwoCache,
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
        let trimmedString = String(data: data, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
        sessionID = trimmedString;
    }

    task.resume()
}


// Get the current temperature, max session temperature, and min session temperature from the backend
func getTemperatureData(callback_func: @escaping (_: String, _: String, _: String) -> (),
                        callback_func_2: @escaping (_: String, _: String, _: String) -> ()) {
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
    print("Getting temperature from the backend...")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Convert HTTP Response Data to a simple String
        var dataDict = ["current_temp_1": 100.0, "current_temp_2": 100.0,
                        "min_temp_1": 50.0, "min_temp_2": 50.0,
                        "max_temp_1": 200.0, "max_temp_2": 200.0]
        do {
            dataDict = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Double])!;
        } catch {
            print("Unable to convert to dictionary")
        }
        if (dataDict["min_temp_1"] != nil && dataDict["max_temp_1"] != nil && dataDict["current_temp_1"] != nil) {
            callback_func(String(dataDict["min_temp_1"]!), String(dataDict["current_temp_1"]!), String(dataDict["max_temp_1"]!))
        }
        if (dataDict["min_temp_2"] != nil && dataDict["max_temp_2"] != nil && dataDict["current_temp_2"] != nil) {
            callback_func_2(String(dataDict["min_temp_2"]!), String(dataDict["current_temp_2"]!), String(dataDict["max_temp_2"]!))
        }
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


// Get a list of 10 sample battery percentages from the current session
func getBatteryPercentages(callback_func: @escaping (_: [[Double]]) -> ()) {
    if (sessionID == "") {
        return
    }
    let url = URL(string: urlBase + "batteryPercentages?sessionID=" + sessionID)
    
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    request.setValue(sessionID, forHTTPHeaderField: "SessionID")
    // Send HTTP Request
    print("Getting battery percentages from the backend...")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
            let responseObject = try JSONDecoder().decode([[Double]].self, from: data!)
            callback_func(responseObject)
        } catch {
            print(error) // parsing error
            
            // Convert HTTP Response Data to a simple String
            if (data != nil) {
                print(type(of: data))
                let trimmedString = String(data: data!, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
                print(trimmedString)
            }
        }
        
    }
    task.resume()
}

// Get the most recent data (smoothed out) about this session (exits gracefully if there is no current session)
func getMostRecentData(callback_func: @escaping (_: [String: Double]) -> ()) {
    if (sessionID == "") {
        return
    }
    let url = URL(string: urlBase + "mostRecentData?sessionID=" + sessionID)
    
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    request.setValue(sessionID, forHTTPHeaderField: "SessionID")
    // Send HTTP Request
    print("Getting most recent battery data from the backend...")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
            let responseObject = try JSONDecoder().decode([String: Double].self, from: data!)
            callback_func(responseObject)
        } catch {
            print(error) // parsing error
            
            // Convert HTTP Response Data to a simple String
            if (data != nil) {
                print(type(of: data))
                let trimmedString = String(data: data!, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
                print(trimmedString)
            }
        }
        
    }
    task.resume()
}

// Gets the public user information for the currently signed in user (first/last name and email)
func getUserData(callback_func: @escaping (_: [String: String]) -> ()) -> Bool {
    if (userID == "") {
        return false
    }
    let url = URL(string: urlBase + "userData?userID=" + userID)
    
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    request.setValue(userID, forHTTPHeaderField: "userID")
    // Send HTTP Request
    print("Getting user data from the backend...")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
            let responseObject = try JSONDecoder().decode([String: String].self, from: data!)
            callback_func(responseObject)
        } catch {
            print(error) // parsing error
            
            // Convert HTTP Response Data to a simple String
            if (data != nil) {
                let trimmedString = String(data: data!, encoding: .utf8)!.components(separatedBy: .whitespacesAndNewlines).joined()
                print(trimmedString)
            }
        }
        
    }
    task.resume()
    return true
}
