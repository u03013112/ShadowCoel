//
//  SimpleManager.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/9.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation

open class SimpleManager {
    public static let sharedManager = SimpleManager()
    
    public var token = "" {
        didSet {
            if (oldValue ~= token){
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
            }
        }
    }
    public var username = "" {
        didSet {
            
        }
    }
}
