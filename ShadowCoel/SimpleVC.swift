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
        return section
    }
    func showLogin() {
        let vc = LoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
