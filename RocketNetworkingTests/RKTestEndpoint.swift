//
//  RKTestEndpoint.swift
//  RocketNetworkingTests
//
//  Created by Will Brandin on 1/26/19.
//  Copyright © 2019 williambrandin. All rights reserved.
//

import Foundation
import RocketNetworking

enum RKTestEndpoint: EndPointType {
    case getSchool(id: String)
    case submitForm(data: ContactForm)
    
    var environmentBaseURL: String {
        return "http://stg.schoolconnected.net/api"
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("base url could not be config") }
        return url
    }
    
    var path: String {
        switch self {
        case .getSchool(id: let id):
            return "/school/info/\(id)"
        case .submitForm:
            return "/message/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getSchool: return .get
        case .submitForm: return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .submitForm(let data):
            return .requestParameters(bodyParameters: data, urlParameters: nil)
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .submitForm:
            return ["hello": "world"]
        default:
            return nil
        }
    }
}
