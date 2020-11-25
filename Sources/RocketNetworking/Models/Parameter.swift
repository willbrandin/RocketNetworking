//
//  Parameter.swift
//  RocketNetworking
//
//  Created by Will Brandin on 11/24/20.
//  Copyright © 2020 williambrandin. All rights reserved.
//

import Foundation

public struct Parameter {
    public let key: String
    public let value: Any
    
    public init(key: String, value: Any) {
        self.key = key
        self.value = value
    }
}
