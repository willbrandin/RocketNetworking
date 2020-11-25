//
//  RKRequestBuilder.swift
//  RocketNetworking
//
//  Created by Will Brandin on 11/24/20.
//  Copyright © 2020 williambrandin. All rights reserved.
//

import Foundation

internal struct SKRequestBuilder {
    
    // MARK: - Properties
    
    private var route: EndPoint
    
    // MARK: - Initializer
    
    init(route: EndPoint) {
        self.route = route
    }
    
    // MARK: - Methods
    
    func buildRequest() throws -> URLRequest {
        // If path is empty, do not add extra '/' at the end of the url
        let url = route.path.isEmpty ? route.baseURL : route.baseURL.appendingPathComponent(route.path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = route.httpMethod.rawValue
        request.timeoutInterval = Constants.defaultHTTPTimeOut
        
        self.additionalHeaders(route.headers, request: &request)

        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
                
            case .requestParameters(let bodyParams, let urlParams):
                try configureParameters(bodyParameters: bodyParams, urlParameters: urlParams, request: &request)
                
            case .requestBodyData(let data, let urlParams):
                try configureParameters(bodyParameters: nil, bodyData: data, urlParameters: urlParams, request: &request)

            case .requestParametersAndHeaders(let bodyParams, let urlParams, let additionalHeaders):
                self.additionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParams, urlParameters: urlParams, request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    private func configureParameters(bodyParameters: Codable?, bodyData: Data? = nil, urlParameters: [Parameter]?, request: inout URLRequest) throws {
        do {
            if let parameters = bodyData {
                JSONParameterEncoder.encode(urlRequest: &request, with: parameters)
            } else if let parameters = bodyParameters {
                guard let data = parameters.toJSONData() else {
                    throw APIError.jsonConversionFailure
                }
                
                JSONParameterEncoder.encode(urlRequest: &request, with: data)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else {
            return
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
