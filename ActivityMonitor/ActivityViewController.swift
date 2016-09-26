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
    
    let MULTIPLIER: Double = 10.0
    let BOUND: Int = 50
    
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
//            self.accelDataSet.append(data: data!)
            self.chartUpdateHandler(data: data!)
            
            // dispatch UI update on main thread
            DispatchQueue.main.async {
                self.xAccel.text = String(format:"%f", accel.x * 10.0)
                self.yAccel.text = String(format:"%f", accel.y * 10.0)
                self.zAccel.text = String(format:"%f", accel.z * 10.0)
                
            }
        }
    }
    
    func chartUpdateHandler(data: CMAccelerometerData) {
        let xEntry = ChartDataEntry(x: data.timestamp, y: self.MULTIPLIER * data.acceleration.x)
        let yEntry = ChartDataEntry(x: data.timestamp, y: self.MULTIPLIER * data.acceleration.y)
        let zEntry = ChartDataEntry(x: data.timestamp, y: self.MULTIPLIER * data.acceleration.z)
        
        
        
        if self.lineChartView.data == nil {
            let xSet = LineChartDataSet(values: [xEntry], label: "X")
            xSet.setColor(NSUIColor.red)
            xSet.drawCirclesEnabled = false
            xSet.drawValuesEnabled = false
            
            let ySet = LineChartDataSet(values: [yEntry], label: "Y")
            
            ySet.setColor(NSUIColor.blue)
            ySet.drawCirclesEnabled = false
            ySet.drawValuesEnabled = false
            
            let zSet = LineChartDataSet(values: [zEntry], label: "Z")
            zSet.setColor(NSUIColor.green)
            zSet.drawCirclesEnabled = false
            zSet.drawValuesEnabled = false
            
            let lineChartData = LineChartData(dataSets: [xSet, ySet, zSet])
            
            // dispatch UI update on main thread
            DispatchQueue.main.async {
                self.lineChartView.data = lineChartData
            }
            
        } else {
            DispatchQueue.main.async {
                if (self.lineChartView.data?.dataSets[0].entryCount)! == self.BOUND {
                    self.lineChartView.data?.dataSets[0].removeFirst()
                    self.lineChartView.data?.dataSets[1].removeFirst()
                    self.lineChartView.data?.dataSets[2].removeFirst()
                }
                
                self.lineChartView.data?.addEntry(xEntry, dataSetIndex: 0)
                self.lineChartView.data?.addEntry(yEntry, dataSetIndex: 1)
                self.lineChartView.data?.addEntry(zEntry, dataSetIndex: 2)
                
                self.lineChartView.data?.notifyDataChanged()
                self.lineChartView.notifyDataSetChanged()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        
        lineChartView.backgroundColor = NSUIColor.clear
        lineChartView.xAxis.drawLabelsEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

