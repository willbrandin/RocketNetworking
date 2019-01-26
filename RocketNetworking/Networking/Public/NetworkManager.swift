//
//  NetworkManager.swift
//  SchoolConnectOnBoarding
//
//  Created by William Brandin on 4/9/18.
//  Copyright © 2018 William Brandin. All rights reserved.
//

import Foundation

public final class RocketNetworkManager<RocketApi: EndPointType> {
    // MARK: - Properties
    public var environment: NetworkEnvironment {
        return rocketEnvironment ?? .development
    }

    private var rocketEnvironment: NetworkEnvironment?
    
    private var router: Router<RocketApi> {
        return Router<RocketApi>()
    }
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Methods
    public func setupNetworkLayer(in environment: NetworkEnvironment) {
        rocketEnvironment = environment
    }
    
    /**
     Submits a request for the specified `Endpoint` provided.
     Request should send back a JSON object which can be decoded to the Codable` type provided.
     - important:
     DecodingType must conform to Codable
     
     - parameters:
     - apiEndpoint: Endpoint of the request.
     - decodingType: The type to decode.
     - completion: The Result enum allows for a switch statement to be used when the method is called.
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
    
    /**
     Submits a request for the specified `Endpoint` provided.
     Request should send back a list of JSON objects which can be decoded to the `Codable` type provided.
     - important:
     DecodingType must be [Codable]
     
     - parameters:
     - apiEndpoint: Endpoint of the request.
     - decodingType: The type to decode.
     - completion: The Result enum allows for a switch statement to be used when the method is called.
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
    
    // MARK: - Private Methods
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponseResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        default: return .failure
        }
    }
    
}
