//
//  Data+JSONPrettyPrint.swift
//  RocketNetworking
//
//  Created by Will Brandin on 11/24/20.
//  Copyright © 2020 williambrandin. All rights reserved.
//

import Foundation

extension Data {
    // https://gist.github.com/cprovatas/5c9f51813bc784ef1d7fcbfb89de74fe
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                return nil
        }
        
        return prettyPrintedString
    }
}
