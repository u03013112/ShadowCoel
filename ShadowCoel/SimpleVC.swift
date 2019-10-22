//
//  SimpleVC.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/8.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import Eureka
import Alamofire
import Cartography

import SwiftyStoreKit

private let kFormPACMode = "FormPACMode"
private let kFromConnect = "FromConnect"
private let kFromVIPExpire = "FromVIPExpire"

class SimpleVC: FormViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Simple".localized()
        self.tabBarController?.tabBar.barTintColor = Color.TabBackground
        
        view.addSubview(connectButton)
        setupLayout()
        updateConnectButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginSuccess), name: NSNotification.Name(rawValue: kLoginSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        
        if (SimpleManager.sharedManager.isPACMod){
            JRule.setGFW()
        }else{
            JRule.setAll()
        }
        login()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubview(toFront: connectButton)
    }
    fileprivate let connectButtonHeight: CGFloat = 48
    func setupLayout() {
        constrain(connectButton, view) { connectButton, view in
            connectButton.trailing == view.trailing
            connectButton.leading == view.leading
            connectButton.height == connectButtonHeight
            connectButton.bottom == view.bottom
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateLoginSection()
        form.delegate = self
    }
    
    func generateLoginSection() -> Section {
        let section = Section()
        section
            <<< ActionRow(kFromVIPExpire) {
                $0.title = "VIP 有效期："
                $0.value = "-"
                if SimpleManager.sharedManager.expireDate > 0 {
                    $0.value = SimpleManager.sharedManager.timeIntervalChangeToTimeStr(timeInterval: SimpleManager.sharedManager.expireDate)
                }
            }.onCellSelection({(cell, row) -> () in
                cell.setSelected(false, animated: true)
                let vc = PurchaseVC()
                self.navigationController?.pushViewController(vc,animated: true)
            })
            <<< SwitchRow(kFormPACMode) {
                $0.title = "智能路由".localized()
                $0.value = SimpleManager.sharedManager.isPACMod
            }.onChange({ (row) in
                if (Manager.sharedManager.vpnStatus == VPNStatus.on){
                    VPN.restartVPN()
                }
                if row.value == false {
                    SimpleManager.sharedManager.isPACMod = false
                    JRule.setAll()
                }else{
                    SimpleManager.sharedManager.isPACMod = true
                    JRule.setGFW()
                }
                
            })
            <<< ActionRow() {
                $0.title = "充值".localized()
            }.onCellSelection({(cell, row) -> () in
                cell.setSelected(false, animated: true)
                SwiftyStoreKit.purchaseProduct("u0.vpn.vip.month", quantity: 1, atomically: false) { result in
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
                $0.title = "重购".localized()
            }.onCellSelection({(cell, row) -> () in
                cell.setSelected(false, animated: true)
                SwiftyStoreKit.restorePurchases(atomically: false) { results in
                    if results.restoreFailedPurchases.count > 0 {
                        print("Restore Failed: \(results.restoreFailedPurchases)")
                    }
                    else if results.restoredPurchases.count > 0 {
                        for purchase in results.restoredPurchases {
                            
                            // fetch content from your server, then:
                            if purchase.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }
                        }
                        print("Restore Success: \(results.restoredPurchases)")
                    }
                    else {
                        print("Nothing to Restore")
                    }
                }
            })
        return section
    }
    func updateConnectButton() {
        let status = Manager.sharedManager.vpnStatus
        connectButton.isEnabled = [VPNStatus.on, VPNStatus.off].contains(status)
        connectButton.setTitleColor(UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState())
        switch status {
        case .connecting, .disconnecting:
            connectButton.animating = true
        default:
            connectButton.setTitle(status.hintDescription, for: .normal)
            connectButton.animating = false
        }
        connectButton.backgroundColor = status.color
    }
    lazy var connectButton: FlatButton = {
        let v = FlatButton(frame: CGRect.zero)
        v.addTarget(self, action: #selector(connect), for: .touchUpInside)
        return v
    }()
    
    func showLogin() {
        let vc = LoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func connect() {
        if (Manager.sharedManager.vpnStatus == VPNStatus.off) {
            //        登陆成功才能连接
            if (SimpleManager.sharedManager.token == ""){
                showTextHUD("需要登录", dismissAfterDelay: 1.0)
            }else{
                print("获取配置")
                let completion = {
                    (result:[String: Any]?, error:Error?, errStr:String?) -> Void in
                    if let error = error {
                        self.showTextHUD("\(error)", dismissAfterDelay: 1.0)
                        return
                    }
                    if let errStr = errStr {
                        self.showTextHUD(errStr, dismissAfterDelay: 1.0)
                        return
                    }
                    if let result = result {
                        let manager = SimpleManager.sharedManager
                        manager.IP = result["IP"] as! String
                        manager.port = result["port"] as! Int
                        manager.method = result["method"] as! String
                        manager.passwd = result["passwd"] as! String
                        
                        let proxy:Proxy?
                        let proxies = DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
                        if (proxies.count == 0) {
                            print("需要新建")
                            proxy = Proxy()
                            self.save(proxy: proxy, IP: manager.IP, port: manager.port, method: manager.method, passwd: manager.passwd)
                        }else{
                            print("需要修改")
                            proxy = proxies[0]
                            self.save(proxy: proxy, IP: manager.IP, port: manager.port, method: manager.method, passwd: manager.passwd)
                        }
                        let group = CurrentGroupManager.shared.group
                        do{
                            try ConfigurationGroup.changeProxy(forGroupId: group.uuid, proxyId: proxy?.uuid)
                        }catch{
                            
                        }
                        VPN.switchVPN(group) { [unowned self] (error) in
                            if let error = error {
                                Alert.show(self, message: "\("Fail to switch VPN.".localized()) (\(error))")
                            }
                        }
                    }
                }
                getVPNConfig(completion: completion)
            }
        }else if (Manager.sharedManager.vpnStatus == VPNStatus.on) {
            let group = CurrentGroupManager.shared.group
            VPN.switchVPN(group) { [unowned self] (error) in
                if let error = error {
                    Alert.show(self, message: "\("Fail to switch VPN.".localized()) (\(error))")
                }
            }
        }
    }
    
    func save(proxy:Proxy? = nil,IP:String,port:Int,method:String,passwd:String) {
        do{
            let upstreamProxy : Proxy
            if let p = proxy {
                upstreamProxy = Proxy(value: p)
            }else {
                upstreamProxy = Proxy()
            }
            upstreamProxy.type = ProxyType.Shadowsocks
            upstreamProxy.group = nil
            upstreamProxy.name = "J"
            upstreamProxy.host = IP
            upstreamProxy.country = "WW"
            upstreamProxy.port = port
            upstreamProxy.authscheme = method
            upstreamProxy.user = nil
            upstreamProxy.password = passwd
            upstreamProxy.ota = false
            upstreamProxy.ssrProtocol = nil
            upstreamProxy.ssrProtocolParam = nil
            upstreamProxy.ssrObfs = nil
            upstreamProxy.ssrObfsParam = nil
            try DBUtils.add(upstreamProxy)
        }catch{
            showTextHUD("\(error)", dismissAfterDelay: 1.0)
        }
    }
    
    @objc func onLoginSuccess() {
        
    }
    
    @objc func onVPNStatusChanged() {
        updateConnectButton()
    }
    
    
    func getVPNConfig (completion: @escaping ([String: Any]?, Error?, String?) -> Void) {
        let token = SimpleManager.sharedManager.token
        if token == "" {
            return
        }
        let dict = ["token":token]
        
        let completion1 = {
            (result:[String: Any]?, error:Error?) -> Void in
            if let error = error {
                completion(nil,error,nil)
                return
            }
            if let result = result {
                if (result["error"] as? String != nil){
                    completion(nil,nil,result["error"] as? String)
                    return
                }
                let ret = [
                    "IP":result["IP"] as! String,
                    "port":Int(result["port"] as! String) ?? 58700,
                    "method":result["method"] as! String,
                    "passwd":result["passwd"] as! String
                ] as [String : Any]
                completion(ret,nil,nil)
                return
            }
        }
        HTTP.shared.postRequest(urlStr: "http://frp.u03013112.win:18021/v1/ios/config", data: dict, completion: completion1)
    }
    func login() {
        login(success:{ (token,ex) in
            SimpleManager.sharedManager.token = token
            let exRow = self.form.rowBy(tag:kFromVIPExpire) as! ActionRow
            
            exRow.value = SimpleManager.sharedManager.timeIntervalChangeToTimeStr(timeInterval: Double(ex))
            exRow.reload()
        },failed: { (errStr) in
            let alert = UIAlertController(title: "err".localized(), message: errStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "comfirm".localized(), style: .cancel, handler:{ (a) in
//                重新登录，必须成功
                self.login()
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func login (success:@escaping (String,Double)->Void,failed:@escaping (String)->Void) {
        let dict = ["uuid":getUUID()]
        
        let completion = {
            (result:[String: Any]?, error:Error?) -> Void in
            if let error = error {
                print(error)
                failed(error.localizedDescription)
                return
            }
            if let result = result {
                if (result["error"] as? String != nil){
                    failed(result["error"] as! String)
                    return
                }
                if result["expiresDate"] as? String != nil{
                    let exStr = result["expiresDate"] as! String
                    let ex = Double(exStr)
                    success(result["token"] as! String,ex ?? 0)
                    SimpleManager.sharedManager.expireDate = ex ?? 0
                }else{
                    success(result["token"] as! String,0)
//                    这里抓进去充值吧
                }
                return
            }
        }
        HTTP.shared.postRequest(urlStr: "http://frp.u03013112.win:18021/v1/ios/login", data: dict, completion: completion)
    }
}
