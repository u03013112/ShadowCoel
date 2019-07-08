//
//  Importer.swift
//
//  Created by LEI on 4/15/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import Async
import ShadowCoelModel
import ShadowCoelLibrary

struct Importer {
    
    weak var viewController: UIViewController?
    
    init(vc: UIViewController) {
        self.viewController = vc
    }
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
    
    func importConfigFromUrl() {
        var urlTextField: UITextField?
        let alert = UIAlertController(title: "Import Config From URL".localized(), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input URL".localized()
            urlTextField = textField
        }
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action) in
            if let input = urlTextField?.text {
                self.onImportInput(input)
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func importConfigFromQRCode() {
        let vc = QRCodeScannerVC()
        vc?.resultBlock = { [weak vc] result in
            vc?.navigationController?.popViewController(animated: true)
            self.onImportInput(result!)
        }
        vc?.errorBlock = { [weak vc] error in
            vc?.navigationController?.popViewController(animated: true)
            self.viewController?.showTextHUD("\(String(describing: error))", dismissAfterDelay: 1.5)
        }
        viewController?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func onImportInput(_ result: String) {
        if Proxy.uriIsShadowsocks(result) {
            importSS(result)
        } else if Subscribe.uriIsSubscribe(result) {
            let _ = 13
        } else {
            importConfig(result, isURL: true)
        }
    }
    
    func importSS(_ source: String) {
        do {
            let defaultName = "___scanresult"
            let IPLO = IPLocation()
            let proxy = try Proxy(dictionary: ["name": defaultName as AnyObject, "uri": source as AnyObject], inRealm: defaultRealm)
            var urlTextField: UITextField?
            let alert = UIAlertController(title: "Add a new proxy".localized(), message: "Please set name for the new proxy".localized(), preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Input name".localized()
                if proxy.name != defaultName {
                    textField.text = proxy.name
                }
                urlTextField = textField
            }
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .default){ (action) in
                guard let text = urlTextField?.text?.trimmingCharacters(in: CharacterSet.whitespaces) else {
                    self.onConfigSaveCallback(false, error: "Name can't be empty".localized())
                    return
                }
                proxy.name = text
                proxy.country = IPLO.IP2CountryCode(IP: proxy.host) // 自动判断国家
                do {
                    try proxy.validate(inRealm: defaultRealm)
                    try DBUtils.add(proxy)
                    self.onConfigSaveCallback(true, error: nil)
                }catch {
                    self.onConfigSaveCallback(false, error: error)
                }
                })
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel) { action in
                })
            viewController?.dismiss(animated: false, completion: nil) // 修复从相册导入时无法弹出提示框的Bug
            viewController?.present(alert, animated: true, completion: nil)
        }catch {
            self.onConfigSaveCallback(false, error: error)
        }
        if let vc = viewController {
            Alert.show(vc, message: "Fail to parse proxy config".localized())
        }
    }
    
    func importSubscribe(_ source:String) {
        do {
            let defaultName = "___scanresult"
        }
    }
    func importConfig(_ source: String, isURL: Bool) {
        viewController?.showProgreeHUD("Importing Config...".localized())
        Async.background(after: 1) {
            let config = Config()
            do {
                if isURL {
                    if let url = URL(string: source) {
                        try config.setup(url: url)
                    }
                }else {
                    try config.setup(string: source)
                }
                try config.save()
                self.onConfigSaveCallback(true, error: nil)
            }catch {
                self.onConfigSaveCallback(false, error: error)
            }
        }
    }
    
    func onConfigSaveCallback(_ success: Bool, error: Error?) {
        Async.main(after: 0.5) {
            self.viewController?.hideHUD()
            if !success {
                var errorDesc = ""
                if let error = error {
                    errorDesc = "(\(error))"
                }
                if let vc = self.viewController {
                    Alert.show(vc, message: "\("Fail to save config.".localized()) \(errorDesc)")
                }
            }else {
                self.viewController?.showTextHUD("Import Success".localized(), dismissAfterDelay: 1.5)
            }
        }
    }

}
