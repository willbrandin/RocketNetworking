//
//  Router.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

internal final class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: route)
            buildPrintableRequestDescription(request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch  {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
                
            case .requestParameters(let bodyParams, let urlParams):
                try configureParameters(bodyParameters: bodyParams, urlParameters: urlParams, request: &request)
                
            case .requestParametersAndHeaders(let bodyParams, let urlParams, let additionalHeaders):
                self.additionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParams, urlParameters: urlParams, request: &request)
            }
            
            return request
        } catch  {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: PropertyLoopable?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                let parameters = try bodyParameters.allProperties()
                try JSONParameterEncoder.encode(urlRequest: &request, with: parameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest){
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    
    private func buildPrintableRequestDescription(_ request: URLRequest) {
        let routeURL = request.url?.absoluteString ?? ""
        let routeHeaders = request.allHTTPHeaderFields ?? [:]
        var routeBodyData = ""
        if let bodyData = request.httpBody {
            routeBodyData = String(data: bodyData, encoding: String.Encoding.utf8) ?? ""
        }
        
        print("\n======================= Start of Service Request call data ==================== \n=======================REQUEST======================= \n URL:\n \(routeURL)\nHEADER:\n\(routeHeaders)\n Body:\n\(routeBodyData)\n\n======================= End of  Service Request call data ================= \n\n\n")
    }
    
}
