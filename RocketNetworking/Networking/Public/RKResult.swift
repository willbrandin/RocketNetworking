//
//  Result.swift
//  RocketNetworking
//
//  Created by Will Brandin on 1/26/19.
//  Copyright © 2019 williambrandin. All rights reserved.
//

import Foundation

public enum RKResult<T,U> {
    case success(T)
    case error(U)
}
