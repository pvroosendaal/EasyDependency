//
//  StorageBImpl.swift
//  EasyDependency_Example
//
//  Created by Niels Koole on 04/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class StorageBImpl: Storage {
    
    let random: Int = Int(arc4random_uniform(1000))
    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    func retrieve() {
        // Implementation ..
    }
    
    func clear() {
        // Implementation ..
    }
    
    func save() {
        // Implementation ..
    }
}
