//
//  Router.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

internal final class SKRouter: NetworkRouter {
    
    // MARK: - Properties
    
    private var task: URLSessionTask?
    
    // MARK: - Methods
    
    func request(_ route: EndPoint, configuration: URLSessionConfiguration?, completion: @escaping NetworkRouterCompletion) {
        let session = configuration != nil ? URLSession(configuration: configuration!) : URLSession.shared
        let builder = SKRequestBuilder(route: route)
        
        do {
            let request = try builder.buildRequest()
            buildPrintableRequestDescription(request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        
        self.task?.resume()
    }
    
    @available(iOS 13.0, *)
    func combineRequest<T: Decodable>(_ route: EndPoint, _ decodingType: T.Type, configuration: URLSessionConfiguration?, errorHandler: @escaping SKErrorHandler) -> AnyPublisher<T, Error> {
        let session = configuration != nil ? URLSession(configuration: configuration!) : URLSession.shared
        let builder = SKRequestBuilder(route: route)
        
        do {
            let request = try builder.buildRequest()
            buildPrintableRequestDescription(request)
            return session.dataTaskPublisher(for: request)
                .tryMap { [weak self] data, response in
                    guard let response = response as? HTTPURLResponse else {
                        throw APIError.jsonParsingFailure
                    }
                    
                    self?.buildPrintableResponseDescription(response, data)
                    
                    return try errorHandler(data, response)
                }
                .decode(type: decodingType, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Empty(completeImmediately: true)
                .eraseToAnyPublisher()
        }
    }
   
    func cancel() {
        self.task?.cancel()
    }
    
    // MARK: - Private Methods
    
    private func buildPrintableRequestDescription(_ request: URLRequest) {
        let routeURL = request.url?.absoluteString ?? ""
        let routeHeaders = request.allHTTPHeaderFields ?? [:]
        let routeBodyData = request.httpBody?.prettyPrintedJSONString ?? ""
        
        print("\n======================= Start of Service Request call data ==================== \n=======================REQUEST======================= \n URL:\n \(routeURL)\nHEADER:\n\(routeHeaders)\n Body:\n\(routeBodyData)\n\n======================= End of  Service Request call data ================= \n\n\n")
    }
    
    private func buildPrintableResponseDescription(_ response: HTTPURLResponse, _ data: Data?) {
        let routeURL = response.url?.absoluteString ?? ""
        let routeBodyData = data?.prettyPrintedJSONString ?? ""
        
        print("\n======================= Start of Response call data ==================== \n=======================RESPONSE======================= \n URL:\n \(routeURL)\n Body:\n\(routeBodyData)\n\n======================= End of RESPONSE call data ================= \n\n\n")
    }
}
