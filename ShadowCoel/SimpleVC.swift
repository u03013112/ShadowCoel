//
//  SimpleVC.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/8.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import Eureka

class SimpleVC: FormViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Simple".localized()
        self.tabBarController?.tabBar.barTintColor = Color.TabBackground
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
        tableView?.reloadData()
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
            <<< BaseButtonRow() {
                $0.title = "连接".localized()
                }.cellSetup({ (cell, row) -> () in
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                }).onCellSelection({ [unowned self] (cell, row) -> () in
                    self.connect()
                })
        return section
    }
    func showLogin() {
        let vc = LoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    func connect() {
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
                } else if let error = error {
                    print("error: \(error.localizedDescription)")
                }
            }
            HTTP.shared.postRequest(urlStr: "http://frp.u03013112.win:18021/v1/config/get-config", data: dict, completion: completion)
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
}
