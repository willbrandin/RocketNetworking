//
//  NetworkManager.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

public final class SKNetworkManager {
    
    // MARK: - Properties
    /**
     Router responsible for creating and performing the Network Request.
    */
    private var router: NetworkRouter {
        return SKRouter()
    }
    
    // MARK: - Initializer
    
    public init() {}
    
    // MARK: - Methods
    /**
    Submits a request for the specified `Endpoint` provided expecting an object.
    
    ```
    /// delcared as such
    MyTypeName.self
    ```
    
    - Parameters:
       - apiEndpoint: **Endpoint** of the request.
       - errorHandler: An optional handler that allows for API Codes to be tested.
       - completion: RKResult.success is data that can be cast if needed.
    */
    public func request(for endPoint: EndPoint, configuration: URLSessionConfiguration? = nil, errorHandler: @escaping SKErrorHandler = { data, _ in data }, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(endPoint, configuration: configuration) { data, response, error in
            
            guard error == nil,
                let response = response as? HTTPURLResponse,
                let data = data else {
                
                DispatchQueue.main.async {
                    completion(.failure(APIError.requestFailed))
                }
                
                return
            }
            
            self.buildPrintableResponseDescription(response, data)
            do {
                let handledErrorResponseData = try errorHandler(data, response)
                
                DispatchQueue.main.async {
                    completion(.success(handledErrorResponseData))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /**
     Submits a request for the specified `Endpoint` provided expecting an object.
     
     Request should send back a JSON object which can be decoded to the Codable` type provided.
     - important:
     DecodingType must conform to Codable
     
     ```
     /// delcared as such
     MyTypeName.self
     ```
     
     - Parameters:
        - apiEndpoint: **Endpoint** of the request.
        - decodingType: The type that is decoded from the response.
        - errorHandler: An optional handler that allows for API Codes to be tested.
        - completion: RKResult.success is the decodingType passed as an argument.
     */
    public func request<T: Codable>(for apiEndpoint: EndPoint, _ decodingType: T.Type, configuration: URLSessionConfiguration? = nil, errorHandler: @escaping SKErrorHandler = { data, _ in data }, completion: @escaping (Result<T, Error>) -> Void) {
        router.request(apiEndpoint, configuration: configuration) { data, response, error in
            
            guard error == nil,
                let response = response as? HTTPURLResponse,
                let data = data else {
                
                DispatchQueue.main.async {
                    completion(.failure(APIError.requestFailed))
                }
                
                return
            }
            
            self.buildPrintableResponseDescription(response, data)
            do {
                let handledErrorResponseData = try errorHandler(data, response)
                let apiResponse = try JSONDecoder().decode(decodingType, from: handledErrorResponseData)
                
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    public func combineRequest<T: Decodable>(_ route: EndPoint, _ decodingType: T.Type, configuration: URLSessionConfiguration? = nil, errorHandler: @escaping SKErrorHandler = { data, _ in data }) -> AnyPublisher<T, Error> {
        return router.combineRequest(route, decodingType, configuration: configuration, errorHandler: errorHandler)
    }
    
    public func cancelRequest() {
        router.cancel()
    }
    
    // MARK: - Private Methods
    
    private func jsonToString(data: Data) -> String {
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
    
    private func buildPrintableResponseDescription(_ response: HTTPURLResponse, _ data: Data?) {
        let routeURL = response.url?.absoluteString ?? ""
        let routeBodyData = data?.prettyPrintedJSONString ?? ""
        
        print("\n======================= Start of Response call data ==================== \n=======================RESPONSE======================= \n URL:\n \(routeURL)\n Body:\n\(routeBodyData)\n\n======================= End of RESPONSE call data ================= \n\n\n")
    }
}
