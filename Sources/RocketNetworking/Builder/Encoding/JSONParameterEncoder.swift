//
//  JSONParameterEncoder.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

internal struct JSONParameterEncoder: RKEncodable {
    internal static func encode(urlRequest: inout URLRequest, with parameters: Data) {
        urlRequest.httpBody = parameters
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

