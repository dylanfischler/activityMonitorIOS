//
//  IOClient.swift
//  ActivityMonitor
//
//  Created by Dylan Fischler on 9/25/16.
//  Copyright © 2016 Dylan Fischler. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class IOClient: NSObject, GCDAsyncSocketDelegate {
    var socket: GCDAsyncSocket!
    
    override init() {
        super.init()
        
        socket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            print("attempting handshake with socket server...")
            try socket.connect(toHost: "none.cs.umass.edu", onPort: 9999)
        } catch let error {
            print(error)
        }
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("socket connected \(host):\(port)")
    }
    
    func write(strData: String) {
        print(strData)
        let data: Data = strData.data(using: String.Encoding.utf8)!
        self.socket!.write(data, withTimeout: -1.0, tag: 0)
    }
}
