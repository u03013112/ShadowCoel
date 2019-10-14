//
//  SimpleManager.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/9.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation

public let kLoginSuccess = "kProxyServiceVPNStatusNotification"

private let kToken = "kToken"
private let kUsername = "kUsername"
private let kIsPacMod = "kIsPacMod"

open class SimpleManager {
    public static let sharedManager = SimpleManager()
    
    fileprivate init() {
        token = UserDefaults.standard.string(forKey: kToken) ?? ""
        username = UserDefaults.standard.string(forKey: kUsername) ?? ""
        isPACMod = UserDefaults.standard.bool(forKey: kIsPacMod) 
    }
    
    public var token = "" {
        didSet {
            if (oldValue != token){
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kLoginSuccess), object: nil)
                UserDefaults.standard.set(token,forKey: kToken)
            }
        }
    }
    public var username = "" {
        didSet {
            if (oldValue != username){
                UserDefaults.standard.set(username,forKey: kUsername)
            }
        }
    }
    
    public var isPACMod = false {
        didSet {
            if (oldValue != isPACMod){
                UserDefaults.standard.set(isPACMod,forKey: kIsPacMod)
            }
        }
    }
}
