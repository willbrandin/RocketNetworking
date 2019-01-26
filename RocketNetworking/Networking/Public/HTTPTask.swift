//
//  HTTPTask.swift
//  SchoolConnectOnBoarding
//
//  Created by William Brandin on 4/9/18.
//  Copyright © 2018 William Brandin. All rights reserved.
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
