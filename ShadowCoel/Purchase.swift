//
//  Purchase.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/20.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import SwiftyStoreKit

class PurchaseJ : NSObject {
    static public func didPurchaseSuccess (purchase:PurchaseDetails,completion:((String?,Error?) -> Void)? = nil){
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")

                let dict = ["uuid":UUID().uuidString,"":encryptedReceipt]
                let completion = {
                    (result:[String: Any]?, error:Error?) -> Void in
                    if let result = result {
                        if (result["error"] as? String != nil) {
                            print(result["error"] as! String)
                            completion?(result["error"] as? String,nil)
                            return
                        }
                        if purchase.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        print("Purchase Success: \(purchase.productId)")
                        completion?(nil,nil)
                        return
                    } else if let error = error {
                        print("error: \(error.localizedDescription)")
                        completion?("",error)
                        return
                    }
                }
                HTTP.shared.postRequest(urlStr: "http://frp.u03013112.win:18021/v1/ios/purchase", data: dict, completion: completion)
            case .error(let error):
                print("Fetch receipt failed: \(error)")
                completion?("",error)
            }
        }
    }
}



