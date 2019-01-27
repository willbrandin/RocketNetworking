//
//  PropertyLoopable.swift
//  RocketNetworking
//
//  Created by Will Brandin on 12/12/18.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

public protocol PropertyLoopable: Codable {
    func allProperties() throws -> [String: Any]
}
