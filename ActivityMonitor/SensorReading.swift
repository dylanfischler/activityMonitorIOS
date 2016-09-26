//
//  SensorReading.swift
//  ActivityMonitor
//
//  Created by Dylan Fischler on 9/26/16.
//  Copyright © 2016 Dylan Fischler. All rights reserved.
//

import Foundation

class SensorReading {
    
    // A 10-byte hex string identifying the current user.
    let userID: String
    
    // Describes the device
    let deviceType: String
    
    // Unique string identifying the device.
    let deviceID: String
    
    // Identifies the sensor type.
    let sensorType: String
    
    // Indicates when the sensor reading occurred.
    let timestamp: UInt64
    
    init(userID: String, deviceType: String, deviceID: String, sensorType: String, timestamp: UInt64) {
        self.userID = userID
        self.deviceType = deviceType
        self.deviceID = deviceID
        self.sensorType = sensorType
        self.timestamp = timestamp
    }
    
    func getBaseDictObject() -> Dictionary<String, String>{
        var dict = [String: String]()
        dict["user_id"] = self.userID
        dict["device_type"] = self.deviceType
        dict["device_id"] = self.deviceID
        dict["sensor_type"] = self.sensorType

        return dict
    }
    
    func dictToJSonString(dict: Dictionary<String, String>) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            
            guard let string = String.init(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Couldn't convert JSON to string")
                return ""
            }
            return string
        }
        catch {
            print(error)
        }
        
        return ""
    }

    func toJSONString() -> String {
        let dict = self.getBaseDictObject()
        return dictToJSonString(dict: dict)
    }
}
