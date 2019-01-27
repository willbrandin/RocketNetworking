//
//  Endpoint.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2018 William Brandin. All rights reserved.
//

import Foundation

public protocol EndPointType {
    var environmentBaseURL: String { get }
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
