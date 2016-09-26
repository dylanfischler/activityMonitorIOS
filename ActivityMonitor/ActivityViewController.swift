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
    var rawDataSet: Array<CMAccelerometerData>!
    
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
            self.rawDataSet.append(data!)
            
            if self.rawDataSet.count > 10 {
                print("calling update handler")
                self.chartUpdateHandler()
            }
            
            
            // dispatch UI update on main thread
            DispatchQueue.main.async {
                self.xAccel.text = String(format:"%f", accel.x)
                self.yAccel.text = String(format:"%f", accel.y)
                self.zAccel.text = String(format:"%f", accel.z)
                
            }
        }
    }
    
    func chartUpdateHandler() {
        var dataEntries: [ChartDataEntry] = []
        
        for dataObj: CMAccelerometerData in rawDataSet {
            let dataEntry = ChartDataEntry(x: dataObj.timestamp, y: dataObj.acceleration.x)
            dataEntries.append(dataEntry)
        }
        
        print(dataEntries.count)
        
        dataSet = LineChartDataSet(values: dataEntries, label: "X")
        let lineChartData = LineChartData(dataSet: dataSet)
        
        // dispatch UI update on main thread
        DispatchQueue.main.async {
            self.lineChartView.data = lineChartData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        rawDataSet = Array()
        
//        chart = LineChartView(frame: CGRect(x: 0, y: 0, width: 480, height: 350))
        lineChartView.backgroundColor = NSUIColor.clear
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.rightAxis.axisMinimum = 0.0
        
//        var entries: [ChartDataEntry] = Array()
//        
//        for i in 0...10 {
//            let dataEntry = ChartDataEntry(x: Double(i), y: Double(arc4random()))
//            entries.append(dataEntry)
//        }
//
//        
//        dataSet = LineChartDataSet(values: entries, label: "X")
//        lineChartView.data = LineChartData(dataSet: dataSet)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

