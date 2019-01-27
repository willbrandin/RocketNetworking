//
//  Endpoint.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

/**
 Protocol defining the requirements needed for an `Endpoint` (url) for performing a network request.
 
 `EndPointType` is a generic constraint on `RocketNetworkManager` which supplies it to a Router to perform HTTP tasks.
 
 ```
 let myRocketManager = RocketNetworkManager<MyEndPointType>()
 ```
 
 EndPointType works best using Enums. Declaring a `case` for each endpoint allows the ability to `switch` on `self` to configure many api elements.
 Example use for defining the path for the URL.
 ```
 var path: String {
     switch self {
     case .getData: "/endpoint-for-data"
     }
 }
 ```
 */
public protocol EndPointType {
    /**
     Root URL for the set `NetworkEnvironment'
     
     Example use:
     ```
     var environmentBaseUrl: String {
        switch NetworkEnvironment {
        case .development: return "www.dev.api.com"
        case .qa: return "www.qa.api.com"
        case .staging: return "www.staging.api.com"
        case .production: return "www.api.com"
        }
     }
     ```
    */
    var environmentBaseURL: String { get }
    
    /// URL that is created from the `environmentBaseURL`.
    var baseURL: URL { get }
    /**
     String appended to `environmentBaseUrl`
     
     Example use:
     ```
     var path: String {
         switch self {
         case .getData: "/endpoint-for-data"
         }
     }
     ```
     */
    var path: String { get }
    /// HTTP Method for given endpoint
    var httpMethod: HTTPMethod { get }
    /// HTTP Task for given endpoint
    var task: HTTPTask { get }
    /// Headers for given endpoint
    var headers: HTTPHeaders? { get }
}
