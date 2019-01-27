//
//  HTTPTask.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: PropertyLoopable?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: PropertyLoopable?,
        urlParameters: Parameters?,
        additionalHeaders: HTTPHeaders?)
}
