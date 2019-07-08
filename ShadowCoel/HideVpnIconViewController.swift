//
//  HideVpnIconViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/17.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation

class HideVpnIconViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Hide VPN Icon".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil 
        form.removeAll()
        form +++ generateHideVPNIcon()
        form.delegate = self
        tableView.reloadData()
    }
    
    func generateHideVPNIcon() -> Section{
        let section = Section()
        section
            <<< SwitchRow() {
                $0.title = "Hide VPN Icon"
        }
        return section
    }
}
