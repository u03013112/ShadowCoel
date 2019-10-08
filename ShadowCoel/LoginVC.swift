//
//  LoginVC.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/8.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation
import Cartography


private let kFormUsername = "username"
private let kFormPasswd = "passwd"

class LoginVC: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login".localized()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateLogin()
        form.delegate = self
        tableView.reloadData()
    }
    func generateLogin() -> Section {
        let section = Section()
        section
            <<< TextRow(kFormUsername) {
                $0.title = "Username".localized()
                $0.value = ""
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Username".localized()
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
                }
            <<< TextRow(kFormPasswd) {
                $0.title = "Passwd".localized()
                $0.value = ""
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Passwd".localized()
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
                }
            <<< BaseButtonRow() {
                $0.title = "Login".localized()
                }.cellSetup({ (cell, row) -> () in
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                }).onCellSelection({ [unowned self] (cell, row) -> () in
                    self.didLoginButtonClicked()
                })
        return section
    }
    
    @objc func didLoginButtonClicked() {
        let values = form.values()
        let username = values[kFormUsername] as? String
        let passwd = values[kFormPasswd] as? String
        NSLog("%@ %@",username ?? "",passwd ?? "")
    }
}
