//
//  AppInitilizer.swift
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import Appirater
// import LogglyLogger_CocoaLumberjack
import SwiftyStoreKit

let appKey = "02188998de7d4b21830f46fa3440b143"

class AppInitializer: NSObject, AppLifeCycleProtocol {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _  = UIViewController.shared
        
        configLogging()
        configAppirater()
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
//                        PurchaseJ.didPurchaseSuccess(purchase: purchase)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        return true
    }

    func configAppirater() {
        
    }

    func configLogging() {
        let fileLogger = DDFileLogger() // File Logger
        fileLogger?.rollingFrequency = TimeInterval(60*60*24*3)  // 24 hours
        fileLogger?.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger!)
        
        /*
        let logglyLogger = LogglyLogger() // Loggy Logger
        logglyLogger.logglyKey = InfoInternal.sharedInstance().getLogglyAPIKey()
        let fields = LogglyFields()
        fields.userid = User.currentUser.id
        fields.appversion = AppEnv.fullVersion
        let formatter = LogglyFormatter(logglyFieldsDelegate: fields)
        formatter?.alwaysIncludeRawMessage = false
        logglyLogger.logFormatter = formatter
        DDLog.add(logglyLogger)
        */

        #if DEBUG
            DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
            DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
            DDLog.setLevel(DDLogLevel.all, for: DDTTYLogger.self)
            DDLog.setLevel(DDLogLevel.all, for: DDASLLogger.self)
        #else

        #endif
    }
    
}
