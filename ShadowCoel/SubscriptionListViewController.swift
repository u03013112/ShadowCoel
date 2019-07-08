//
//  SubscriptionListViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/5.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import Foundation
import Cartography
import Eureka
import ShadowCoelModel

class SubscriptionListViewController: FormViewController {
    
    var subscribes: [Subscribe?] = []
    let allowNone: Bool
    let chooseCallback: ((Subscribe?) -> Void)?
    
    init(allowNone: Bool = false, chooseCallback: ((Subscribe?) -> Void)? = nil) {
        self.chooseCallback = chooseCallback
        self.allowNone = allowNone
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Subscribe".localized() // 导航栏标题
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add)) // 导航栏右侧按钮
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func add() {
        let vc = SubscriptionConfigurationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func reloadData() {
        subscribes = DBUtils.allNotDeleted(Subscribe.self, sorted: "createAt").map({ $0 })
        if allowNone {
            subscribes.insert(nil, at: 0)
        }
        form.delegate = nil
        form.removeAll()
        let section = Section()
        for subscribe in subscribes {
            section
                <<< SubscribeRow() {
                    $0.value = subscribe
                }.cellSetup({ (cell, row) -> () in
                    cell.selectionStyle = .none
                }).onCellSelection({ [unowned self] (cell, row) in
                    cell.setSelected(false, animated: true)
                    let subscribe = row.value
                    if let cb = self.chooseCallback {
                        cb(subscribe)
                        self.close()
                    }else {
                        self.showSubscribeConfiguration(subscribe)
                    }
            })
        }
        form +++ section
        form.delegate = self
        tableView?.reloadData()
    }
    
    func showSubscribeConfiguration(_ subscribe : Subscribe?) {
        let vc = SubscriptionConfigurationViewController(upstreamSubscribe: subscribe)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if allowNone && indexPath.row == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < subscribes.count, let item = (form[indexPath] as? SubscribeRow)?.value else {
                return
            }
            do {
                try DBUtils.softDelete(item.uuid, type: Subscribe.self)
                subscribes.remove(at: indexPath.row)
                form[indexPath].hidden = true
                form[indexPath].evaluateHidden()
            }catch {
                self.showTextHUD("\("Fail to delete item".localized()): \((error as NSError).localizedDescription)", dismissAfterDelay: 1.5)
            }
        }
    }
    
    // 消除横条化界面
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.tableFooterView = UIView()
        tableView?.tableHeaderView = UIView()
    }
    
}
