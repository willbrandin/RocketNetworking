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
    public func request<T: Codable>(for apiEndpoint: RocketApi, _ decodingType: T.Type, completion: @escaping (RKResult<T, APIError>) -> Void) {
        router.request(apiEndpoint) { data, response, error in
            if error != nil {
                completion(.error(.requestFailed))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.error(.invalidData))
                        return
                    }
                    do {
                        //Decodes the data
                        let apiResonse = try JSONDecoder().decode(decodingType, from: responseData)
                        print("********************************************\n\(self.jsonToString(data: responseData))\n********************************************")
                        completion(.success(apiResonse))
                    } catch {
                        completion(.error(.jsonParsingFailure))
                    }
                    
                case .failure:
                    completion(.error(.responseUnsuccessful))
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
    public func requestWithListResponse<T: Codable>(for apiEndpoint: RocketApi, _ decodingType: [T].Type, completion: @escaping (RKResult<[T], APIError>) -> Void) {
        //gets data based on url...
        router.request(apiEndpoint) { data, response, error in
            if error != nil {
                completion(.error(.requestFailed))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.error(.invalidData))
                        return
                    }
                    do {
                        let apiResonse = try JSONDecoder().decode(decodingType, from: responseData)
                        print("********************************************\n\(apiResonse)\n********************************************")
                        completion(.success(apiResonse))
                    } catch {
                        completion(.error(.jsonParsingFailure))
                    }
                case .failure:
                    completion(.error(.responseUnsuccessful))
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
}
