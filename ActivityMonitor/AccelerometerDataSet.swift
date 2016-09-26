//
//  AccelerometerDataSet.swift
//  ActivityMonitor
//
//  Created by Dylan Fischler on 9/25/16.
//  Copyright © 2016 Dylan Fischler. All rights reserved.
//

import Foundation
import Charts
import CoreMotion

class AccelerometerDataSet {
    var xSet: BoundedArray<ChartDataEntry>!
    var ySet: BoundedArray<ChartDataEntry>!
    var zSet: BoundedArray<ChartDataEntry>!
    
    let multiplier: Double
    
    init(bound: Int, multiplier: Double) {
        xSet = BoundedArray<ChartDataEntry>(bound: bound)
        ySet = BoundedArray<ChartDataEntry>(bound: bound)
        zSet = BoundedArray<ChartDataEntry>(bound: bound)
        self.multiplier = multiplier
    }
    
    func append(data: CMAccelerometerData) {
        xSet.boundedAppend(obj: ChartDataEntry(x: data.timestamp, y: multiplier * data.acceleration.x))
        ySet.boundedAppend(obj: ChartDataEntry(x: data.timestamp, y: multiplier * data.acceleration.y))
        zSet.boundedAppend(obj: ChartDataEntry(x: data.timestamp, y: multiplier * data.acceleration.z))
    }
}
