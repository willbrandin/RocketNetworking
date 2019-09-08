//
//  NetworkManager.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation

/**
 
*/
public final class RocketNetworkManager<RocketApi: EndPointType> {
    
    // MARK: - Properties
    
    /**
     Accessible `getter` for the current `NetworkEnvironment`.
     If `rocketEnvironment` is not set, `environment` defaults to `.development`.
    */
    public var environment: NetworkEnvironment {
        return rocketEnvironment ?? .development
    }
    
    private var rocketEnvironment: NetworkEnvironment?
    
    /**
     Router responsible for creating and performing the Network Request.
    */
    private var router: Router<RocketApi> {
        return Router<RocketApi>()
    }
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Methods
    /**
     Sets the networking environment.
     
     - Parameter environment: The NetworkEnvironment to be set
    */
    public func setupNetworkLayer(in environment: NetworkEnvironment) {
        rocketEnvironment = environment
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
        - completion: RKResult.success is the decodingType passed as an argument.
     */
    public func request<T: Codable>(for apiEndpoint: RocketApi, _ decodingType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        router.request(apiEndpoint) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
            }
            
            if let response = response as? HTTPURLResponse {
                self.buildPrintableResponseDescription(response, data)
                
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.invalidData))
                        return
                    }
                    do {
                        //Decodes the data
                        let apiResonse = try JSONDecoder().decode(decodingType, from: responseData)
                        completion(.success(apiResonse))
                    } catch(let error) {
                        print(error)
                        completion(.failure(.jsonParsingFailure))
                    }
                    
                case .failure:
                    completion(.failure(.responseUnsuccessful))
                }
            }
            
        }
    }
    
    /**
     Submits a request for the specified `Endpoint` provided expecting list in return.
     
     Request should send back a list of JSON objects which can be decoded to the `Codable` type provided.
     - Important:
     DecodingType must be an array of `Codable` objects.
     
     ```
     /// delcared as such
     MyTypeName.self
     ```
     
     - Parameters:
         - apiEndpoint: **Endpoint** of the request.
         - decodingType: The type that is decoded from the response.
         - completion: RKResult.success is the decodingType passed as an argument.
     */
    public func requestWithListResponse<T: Codable>(for apiEndpoint: RocketApi, _ decodingType: [T].Type, completion: @escaping (Result<[T], APIError>) -> Void) {
        //gets data based on url...
        router.request(apiEndpoint) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
            }
            
            if let response = response as? HTTPURLResponse {
                self.buildPrintableResponseDescription(response, data)

                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.invalidData))
                        return
                    }
                    do {
                        let apiResonse = try JSONDecoder().decode(decodingType, from: responseData)
                        completion(.success(apiResonse))
                    } catch let error {
                        print(error)
                        completion(.failure(.jsonParsingFailure))
                    }
                case .failure:
                    completion(.failure(.responseUnsuccessful))
                }
            }
            
        }
    }
    
    public func cancelRequest() {
        router.cancel()
    }
    
    // MARK: - Private Methods
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponseResult{
        switch response.statusCode {
        case 200...299: return .success
        default: return .failure
        }
    }
    
    private func jsonToString(data: Data) -> String {
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
    
    private func buildPrintableResponseDescription(_ response: HTTPURLResponse, _ data: Data?) {
        let routeURL = response.url?.absoluteString ?? ""
        var routeBodyData = ""
        if let bodyData = data {
            routeBodyData = String(data: bodyData, encoding: String.Encoding.utf8) ?? ""
        }
        
        print("\n======================= Start of Response call data ==================== \n=======================RESPONSE======================= \n URL:\n \(routeURL)\n Body:\n\(routeBodyData)\n\n======================= End of RESPONSE call data ================= \n\n\n")
    }
}
