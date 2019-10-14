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

private let kFormPACMode = "FormPACMode"
private let kFromConnect = "FromConnect"

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
        
        if (SimpleManager.sharedManager.token != ""){
//            try 2 get config
            
//            if success,login ok
            
//            if failed,logout
        }
        
        if (SimpleManager.sharedManager.isPACMod){
            JRule.setGFW()
        }else{
            JRule.setAll()
        }
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
        let section = Section("登录")
        section
            <<< ActionRow() {
                $0.title = "登录".localized()
                }.cellUpdate {cell ,_ in
                    cell.imageView?.image = UIImage(named: "HideIcon")?.withRenderingMode(.alwaysTemplate)
                    cell.imageView?.tintColor = Color.ButtonIcon
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    self.showLogin()
                })
            <<< SwitchRow(kFormPACMode) {
                $0.title = "PAC mode".localized()
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
            var IP = ""
            var port = 0
            var method = ""
            var passwd = ""
            //        登陆成功才能连接
            if (SimpleManager.sharedManager.token == ""){
                showTextHUD("需要登录", dismissAfterDelay: 1.0)
            }else{
                print("获取配置")
                var dict = [String:Any]()
                dict["token"] = SimpleManager.sharedManager.token
                let completion = {
                    (result:[String: Any]?, error:Error?) -> Void in
                    if let result = result {
                        if (result["error"] as? String != nil){
                            //
                            self.showTextHUD("获取配置失败", dismissAfterDelay: 1.0)
                            return
                        }
                        IP = result["IP"] as! String
                        port = Int(result["port"] as! String) ?? 58700
                        method = result["method"] as! String
                        passwd = result["passwd"] as! String
                        
                        let proxies = DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
                        if (proxies.count == 0) {
                            print("需要新建")
                            self.save(proxy: nil, IP: IP, port: port, method: method, passwd: passwd)
                        }else{
                            print("需要修改")
                            let proxy = proxies[0]
                            self.save(proxy: proxy, IP: IP, port: port, method: method, passwd: passwd)
                        }
                        
                        let group = CurrentGroupManager.shared.group
                        
                        VPN.switchVPN(group) { [unowned self] (error) in
                            if let error = error {
                                Alert.show(self, message: "\("Fail to switch VPN.".localized()) (\(error))")
                            }
                        }
                    } else if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                }
                HTTP.shared.postRequest(urlStr: "http://frp.u03013112.win:18021/v1/config/get-config", data: dict, completion: completion)
            }
        }
        if (Manager.sharedManager.vpnStatus == VPNStatus.on) {
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
}
