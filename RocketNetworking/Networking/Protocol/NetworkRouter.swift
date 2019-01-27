//
//  NetworkRouter.swift
//  SchoolConnectOnBoarding
//
//  Created by William Brandin on 4/9/18.
//  Copyright © 2018 William Brandin. All rights reserved.
//

import Foundation

/**
 Completion handler for the network router.
 */
typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
