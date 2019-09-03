//
//  ParameterEncoding.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

public typealias Parameters = [String : Any]

/// URL Parameter Encoding
internal protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

/// JSON Body Data encoding
internal protocol RKEncodable {
    static func encode(urlRequest: inout URLRequest, with parameters: Codable) throws
}
