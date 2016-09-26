//
//  AccelerometerReading.swift
//  ActivityMonitor
//
//  Created by Dylan Fischler on 9/26/16.
//  Copyright © 2016 Dylan Fischler. All rights reserved.
//

import Foundation

class AccelerometerReading: SensorReading {
    let x: Double
    let y: Double
    let z: Double
    
    init(x: Double, y: Double, z: Double, userID: String, deviceType: String, deviceID: String, timestamp: UInt64) {
        self.x = x
        self.y = y
        self.z = z
        
        super.init(userID: userID, deviceType: deviceType, deviceID: deviceID, sensorType: "SENSOR_ACCEL", timestamp: timestamp)
        
    }
    
    func getDataDictAsString(data: Dictionary<String, String>) -> String {
        return self.dictToJSonString(dict: data)
    }
    
    override func getBaseDictObject() -> Dictionary<String, String> {
        var dict = super.getBaseDictObject()
        
        let dataStr = getDataDictAsString(data: [
            "t": String(format: "%f", self.timestamp),
            "x": String(format: "%f", self.x),
            "y": String(format: "%f", self.y),
            "z": String(format: "%f", self.z)
        ])
        
        dict["data"] = dataStr
        
        return dict
    }

    
    
    
}
