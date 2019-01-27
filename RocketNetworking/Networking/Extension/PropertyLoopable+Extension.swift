//
//  PropertyLoopable+Extension.swift
//  RocketNetworking
//
//  Created by Will Brandin on 1/26/19.
//  Copyright © 2019 williambrandin. All rights reserved.
//

import Foundation

public extension PropertyLoopable {
    public func allProperties() throws -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            result[property] = value
        }
        
        return result
    }
}
