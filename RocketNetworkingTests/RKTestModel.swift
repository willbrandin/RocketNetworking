//
//  RKTestModel.swift
//  RocketNetworkingTests
//
//  Created by Will Brandin on 1/26/19.
//  Copyright © 2019 williambrandin. All rights reserved.
//

import Foundation
import RocketNetworking

class School: Codable {
    
    //MARK: - Properties
    let schoolName: String?
    let schoolId: String?
    let schoolCity: String?
    let schoolState: String?
    
    enum CodingKeys: String, CodingKey {
        case schoolCity = "city"
        case schoolState = "state"
        case schoolName = "name"
        case schoolId = "school"
    }
    
}

public struct ContactForm: PropertyLoopable {
    
    //MARK: - Properties
    var name: String?
    var email: String?
    var phoneNumber: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case name, email, phoneNumber, message
    }
}
