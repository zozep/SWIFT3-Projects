//
//  MutableCollection+EXT.swift
//  POPExp
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation

//only where a mutable collection has an integer index, we are going to extend it
extension MutableCollection where Index == Int {
    mutating func shuffle() {
        if count  < 2 { return }
        
        //shuffling tacos
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
