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
    case requestParameters(bodyParameters: Codable?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Codable?,
        urlParameters: Parameters?,
        additionalHeaders: HTTPHeaders?)
}
