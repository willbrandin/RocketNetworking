//
//  NetworkRouter.swift
//  RocketNetworking
//
//  Created by William Brandin on 1/26/19.
//  Copyright © 2019 William Brandin. All rights reserved.
//

import Foundation
import Combine

/**
 Completion handler for the network router.
 */
typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

/**
 Completion handler for handling errors given from API
 */
public typealias SKErrorHandler = (Data, HTTPURLResponse) throws -> Data

protocol NetworkRouter: class {
    func request(_ route: EndPoint, configuration: URLSessionConfiguration?, completion: @escaping NetworkRouterCompletion)
    @available(iOS 13.0, *)
    func combineRequest<T: Decodable>(_ route: EndPoint, _ decodingType: T.Type, configuration: URLSessionConfiguration?, errorHandler: @escaping SKErrorHandler) -> AnyPublisher<T, Error>
    func cancel()
}
