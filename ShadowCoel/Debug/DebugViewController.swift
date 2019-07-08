//
//  DebugViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/9.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation

class DebugViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Debug".localized()
        self.tabBarController?.tabBar.barTintColor = Color.TabBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ GenerateColorSection()
        form +++ GenerateIconSection()
        form.delegate = self
        tableView?.reloadData()
    }
    
    
    func GenerateColorSection() -> Section {
        let section = Section("Color")
        section
            <<< ActionRow() {
                $0.title = "Change Color"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    self.showChangeColor()
                })
            <<< ActionRow() {
                $0.title = "Reset Color"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    self.resetColor()
                })
            <<< ActionRow() {
                $0.title = "Copy Url"
        }
        
        return section
    }
    
    func GenerateIconSection() -> Section {
        let section = Section("Icon")
        section
            <<< ActionRow() {
                $0.title = "Change Icon"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    self.showChangeIcon()
                })
        return section
    }
    func showChangeColor() {
        let vc = ColorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func resetColor() {
        let CM = ColorManager()
        CM.resetColor()
    }
    
    func showChangeIcon() {
        let vc = IconViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
