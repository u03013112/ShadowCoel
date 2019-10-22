//
//  UUID.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/21.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation

public func getUUID()->String{
    let uuid = try? keychain.get("U0.SS.UUID")
    if let uuid = uuid as? String{
        return uuid
    }else{
        let str = UUID().uuidString
        do {
            try keychain.set(str, key: "U0.SS.UUID")
        } catch let error {
            print(error)
        }
        return str
    }
}
