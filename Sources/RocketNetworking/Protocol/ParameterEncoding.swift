//
//  ParameterEncoding.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

/// URL Parameter Encoding
internal protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: [Parameter]) throws
}

/// JSON Body Data encoding
internal protocol RKEncodable {
    static func encode(urlRequest: inout URLRequest, with parameters: Data)
}
