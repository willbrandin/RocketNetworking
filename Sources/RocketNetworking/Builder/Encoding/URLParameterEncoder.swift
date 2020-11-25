//
//  URLParameterEncoder.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

internal struct URLParameterEncoder: ParameterEncoder {
    internal static func encode(urlRequest: inout URLRequest, with parameters: [Parameter]) throws {
        
        guard let url = urlRequest.url else {
            throw APIError.requestFailed
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for parameter in parameters {
                let queryItem = URLQueryItem(name: parameter.key, value: "\(parameter.value)")
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
        }
    }
}
