//
//  BoundedArray.swift
//  ActivityMonitor
//
//  Created by Dylan Fischler on 9/25/16.
//  Copyright © 2016 Dylan Fischler. All rights reserved.
//

import Foundation

class BoundedArray<T> {
    let BOUND: Int
    var array: Array<T>
    
    init(bound: Int) {
        self.BOUND = bound
        self.array = Array<T>()
    }
    
    func boundedAppend(obj: T) {
        if array.count == BOUND {
            array.removeFirst()
        }
        
        array.append(obj)
    }
}
