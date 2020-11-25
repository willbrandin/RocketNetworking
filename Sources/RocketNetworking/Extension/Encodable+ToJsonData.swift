//
//  Encodable+ToJsonData.swift
//  RocketNetworking
//
//  Created by Will Brandin on 9/3/19.
//  Copyright © 2019 williambrandin. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
