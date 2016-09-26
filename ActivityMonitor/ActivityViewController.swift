//
//  ActivityViewController.swift
//  ActivityMonitor
//
//  Created by Dylan Fischler on 9/25/16.
//  Copyright © 2016 Dylan Fischler. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class ActivityViewController: UIViewController {

    @IBOutlet weak var accelSwitch: UISwitch!
    
    @IBOutlet weak var xAccel: UILabel!
    @IBOutlet weak var yAccel: UILabel!
    @IBOutlet weak var zAccel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var motionManager: CMMotionManager!
    
    var dataSet: LineChartDataSet!
    var rawDataSet: BoundedArray<ChartDataEntry>!
    
    @IBAction func switchListener(_ sender: AnyObject) {
        if accelSwitch.isOn {
            toggleAccelerometer(on: true)
            
        } else {
            toggleAccelerometer(on: false)
        }
    }
    
    func toggleAccelerometer(on: Bool) {
        if on {
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = SensorSampleRate.ACCEL_SAMPLE
                
                print("starting accelerometer listener")
                motionManager.startAccelerometerUpdates(to: OperationQueue(), withHandler:accelUpdateHandler)
            }
        } else {
            print("stopping accelerometer listener")
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func accelUpdateHandler(data: CMAccelerometerData?, error: Error?) {
        if let accel = data?.acceleration {
            self.rawDataSet.boundedAppend(obj: ChartDataEntry(x: data!.timestamp, y: accel.x))
            self.chartUpdateHandler()
            
            // dispatch UI update on main thread
            DispatchQueue.main.async {
                self.xAccel.text = String(format:"%f", accel.x)
                self.yAccel.text = String(format:"%f", accel.y)
                self.zAccel.text = String(format:"%f", accel.z)
                
            }
        }
    }
    
    func chartUpdateHandler() {
        dataSet = LineChartDataSet(values: rawDataSet.array, label: "X")
        let lineChartData = LineChartData(dataSet: dataSet)
        
        // dispatch UI update on main thread
        DispatchQueue.main.async {
            self.lineChartView.data = lineChartData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        rawDataSet = BoundedArray(bound: 100)
        
        lineChartView.backgroundColor = NSUIColor.clear
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.rightAxis.axisMinimum = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

