//
//  SubscriptionConfigurationViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/27.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import Eureka
import Async

public enum SubscriptionError: Error {
    case Error(String)
}

private let kSubscribeFormName = "name"
private let kSubscribeFormUpdate = "update"
private let kSubscribeFormUrl = "url"

class SubscriptionConfigurationViewController: FormViewController {
    
    var sbMgr: SubscribeManager
    var upstreamSubscribe: Subscribe
    let isEdit: Bool
    
    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init()
    }
    
    init(upstreamSubscribe: Subscribe? = nil) {
        if let subscribe = upstreamSubscribe {
            self.upstreamSubscribe = Subscribe(value: subscribe)
            self.isEdit = true
        }else {
            self.upstreamSubscribe = Subscribe()
            self.isEdit = false
        }
        self.sbMgr = SubscribeManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            self.navigationItem.title = "Edit Subscription".localized()
        }else {
            self.navigationItem.title = "Add Subsription".localized()
        }
        generateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }
    
    func generateForm() {
        form +++ Section()
            <<< TextRow(kSubscribeFormName) {
                $0.title = "Name".localized()
                $0.value = self.upstreamSubscribe.name
                }.cellSetup { cell, row in
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
                }
            <<< SwitchRow() {
                $0.title = "Auto Update".localized()
                $0.value = self.upstreamSubscribe.update
            }
            <<< TextRow(kSubscribeFormUrl) {
                $0.title = "URL".localized()
                $0.value = self.upstreamSubscribe.url
                }.cellSetup { cell, row in
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
                }
        form +++ Section()
            <<< ActionRow() {
                $0.title = "Share QRCode".localized()
                $0.hidden = Condition(booleanLiteral: !isEdit)
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.shareQRCode()
                })
            <<< ActionRow() {
                $0.title = "Share Url".localized()
                $0.hidden = Condition(booleanLiteral: !isEdit)
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.shareuri()
                })
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Delete".localized()
                $0.hidden = Condition(booleanLiteral: !isEdit)
                }.cellUpdate({ cell, row in
                    cell.textLabel?.textColor = UIColor.red // 设置颜色为红色
                }).onCellSelection({ [unowned self] (cell, row) -> () in
                    self.deletesubscribe()
                })
    }
    
    func shareQRCode() {
        let vc = QRCodeViewController(url: self.upstreamSubscribe.Uri())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func shareuri() {
        UIPasteboard.general.string = self.upstreamSubscribe.Uri()
        showTextHUD("Success".localized(), dismissAfterDelay: 1.0)
    }
    
    func deletesubscribe() {
        let subscribes = DBUtils.all(Subscribe.self, sorted: "createAt").map({ $0 })
        for ep in subscribes {
            if ep.name == self.upstreamSubscribe.name,
                ep.url == self.upstreamSubscribe.url {
                print ("Remove existing: " + self.upstreamSubscribe.name)
                self.navigationController?.popViewController(animated: true)
                try? DBUtils.softDelete(ep.uuid, type: Subscribe.self)
            }
        }
    }
    
    @objc func save() {
        do {
            let values = form.values()
            guard let name = (values[kSubscribeFormName] as? String)?.trimmingCharacters(in: CharacterSet.whitespaces), !name.isEmpty else {
                throw SubscriptionError.Error("Name can not be empty".localized())
            }
            guard let url = (values[kSubscribeFormUrl] as? String)?.trimmingCharacters(in: CharacterSet.whitespaces), !url.isEmpty else {
                throw SubscriptionError.Error("Url can not be empty".localized())
            }
            upstreamSubscribe.name = name
            upstreamSubscribe.url = url
            try DBUtils.add(upstreamSubscribe)
            sbMgr.updateSubscribe(url: url)
            let time = 1.0
            showTextHUD("Success".localized(), dismissAfterDelay: time)
            Async.main(after: time) {
                self.close()
            }
            } catch {
            showTextHUD("\(error)", dismissAfterDelay: 1.0)
        }
    }
}
