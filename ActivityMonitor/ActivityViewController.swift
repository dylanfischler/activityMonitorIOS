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
    var accelDataSet: AccelerometerDataSet!
    
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
            self.accelDataSet.append(data: data!)
            self.chartUpdateHandler()
            
            // dispatch UI update on main thread
            DispatchQueue.main.async {
                self.xAccel.text = String(format:"%f", accel.x * 10.0)
                self.yAccel.text = String(format:"%f", accel.y * 10.0)
                self.zAccel.text = String(format:"%f", accel.z * 10.0)
                
            }
        }
    }
    
    func chartUpdateHandler() {
        let xSet = LineChartDataSet(values: accelDataSet.xSet.array, label: "X")
        xSet.setColor(NSUIColor.red)
        xSet.drawCirclesEnabled = false
        xSet.drawValuesEnabled = false
        
        let ySet = LineChartDataSet(values: accelDataSet.ySet.array, label: "Y")
        ySet.setColor(NSUIColor.blue)
        ySet.drawCirclesEnabled = false
        ySet.drawValuesEnabled = false
        
        let zSet = LineChartDataSet(values: accelDataSet.zSet.array, label: "Z")
        zSet.setColor(NSUIColor.green)
        zSet.drawCirclesEnabled = false
        zSet.drawValuesEnabled = false
        
        let lineChartData = LineChartData(dataSets: [xSet, ySet, zSet])
        
        
        // dispatch UI update on main thread
        DispatchQueue.main.async {
            self.lineChartView.data = lineChartData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        accelDataSet = AccelerometerDataSet(bound: 100, multiplier: 10.0)
        
        lineChartView.backgroundColor = NSUIColor.clear
        lineChartView.xAxis.drawLabelsEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

