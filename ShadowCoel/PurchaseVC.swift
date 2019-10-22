//
//  PurchaseVC.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/22.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation
import SwiftyStoreKit

class PurchaseVC: FormViewController {
    var isShowing:String?
    var block:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "充值".localized()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateStatus()
        form +++ generatePurchase()
        form.delegate = self
        tableView.reloadData()
    }
    func generateStatus() -> Section {
        let section = Section("")
        section
            <<< ActionRow() {
                $0.title = "VIP 有效期："
                $0.value = "-"
                if SimpleManager.sharedManager.expireDate > 0 {
                    $0.value = SimpleManager.sharedManager.timeIntervalChangeToTimeStr(timeInterval: SimpleManager.sharedManager.expireDate)
                }
            }.onCellSelection({(cell, row) -> () in
                cell.setSelected(false, animated: true)
            })
        return section
    }
    func generatePurchase() -> Section {
        let section = Section("")
        section
            <<< ActionRow() {
                $0.title = "连续包周".localized()
                $0.value = "￥3"
                }.onCellSelection({ (cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    if self.isShowing != "w" {
                        self.isShowing = "w"
                    }else{
                        self.isShowing = ""
                    }
                    self.generateForm()
                })
            <<< LabelRow(){
                if (self.isShowing != "w"){
                    $0.hidden = true
                }
                $0.title = "Switch is on!"
            }
            <<< BaseButtonRow() {
                if (self.isShowing != "w"){
                    $0.hidden = true
                }
                $0.title = "支付".localized()
                }.cellSetup({ (cell, row) -> () in
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                }).onCellSelection({(cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    self.pushBlockView()
                    SwiftyStoreKit.purchaseProduct("u0.vpn.vip.week", quantity: 1, atomically: false) { result in
                        self.block?.dismiss()
                        self.block = nil
                        switch result {
                        case .success(let purchase):
                            PurchaseJ.didPurchaseSuccess(purchase: purchase)
                        case .error(let error):
                            switch error.code {
                            case .unknown: print("Unknown error. Please contact support")
                            case .clientInvalid: print("Not allowed to make the payment")
                            case .paymentCancelled: break
                            case .paymentInvalid: print("The purchase identifier was invalid")
                            case .paymentNotAllowed: print("The device is not allowed to make the payment")
                            case .storeProductNotAvailable: print("The product is not available in the current storefront")
                            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                            default: print((error as NSError).localizedDescription)
                            }
                        }
                    }
                })
            <<< ActionRow() {
                $0.title = "连续包月".localized()
                $0.value = "￥10"
                }.onCellSelection({ (cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    if self.isShowing != "m" {
                        self.isShowing = "m"
                    }else{
                        self.isShowing = ""
                    }
                    self.generateForm()
                })
            <<< LabelRow(){
                if (self.isShowing != "m"){
                    $0.hidden = true
                }
                $0.title = "Switch is on!"
                }
            <<< BaseButtonRow() {
                if (self.isShowing != "m"){
                    $0.hidden = true
                }
                $0.title = "支付".localized()
                }.cellSetup({ (cell, row) -> () in
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                }).onCellSelection({(cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    self.pushBlockView()
                    SwiftyStoreKit.purchaseProduct("u0.vpn.vip.month", quantity: 1, atomically: false) { result in
                        self.block?.dismiss()
                        self.block = nil
                        switch result {
                        case .success(let purchase):
                            PurchaseJ.didPurchaseSuccess(purchase: purchase)
                        case .error(let error):
                            switch error.code {
                            case .unknown: print("Unknown error. Please contact support")
                            case .clientInvalid: print("Not allowed to make the payment")
                            case .paymentCancelled: break
                            case .paymentInvalid: print("The purchase identifier was invalid")
                            case .paymentNotAllowed: print("The device is not allowed to make the payment")
                            case .storeProductNotAvailable: print("The product is not available in the current storefront")
                            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                            default: print((error as NSError).localizedDescription)
                            }
                        }
                    }
                })
        
        return section
    }
    func getPrice () {
        SwiftyStoreKit.retrieveProductsInfo(["u0.vpn.vip.month"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    func pushBlockView() -> Void {
        self.block = UIAlertController(title: "联系苹果中，请稍后".localized(), message: nil, preferredStyle: .alert)
        self.present((self.block ?? nil)! , animated: true, completion: nil)
    }
}
