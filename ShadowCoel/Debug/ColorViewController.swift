//
//  ColorViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/9.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation

private let kColorFormBC = "bc"
private let kColorFormSC = "sc"
private let kColorFormBC2 = "bc2"
private let kColorFormNBC = "nbc"
private let kColorFormNTC = "ntc"
private let kColorFormTBC = "tbc"
private let kColorFormTBSC = "tbsc"
private let kColorFormTBUC = "tbuc"
private let kColorFormCBC = "cbc"
private let kColorFormCBD = "cbd"
private let kColorFormBIC = "bic"

class ColorViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Color"
        self.tabBarController?.tabBar.barTintColor = Color.TabBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateOverallColor()
        form +++ generateNavigationColor()
        form +++ generateTabColor()
        form +++ generateConnectButtonColor()
        form +++ generateButtonColor()
        form +++ generatePingColor()
        form.delegate = self
        tableView.reloadData()
    }
    
    func generateOverallColor() -> Section {
        let section = Section()
        section
            <<< TextRow(kColorFormBC) {
                $0.title = "BrandColor"
                $0.value = Color.Brand.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.Brand.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow(kColorFormSC) {
                $0.title = "SeperatorColor"
                $0.value = Color.Separator.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.Separator.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow() {
                $0.title = "BackgroundColor"
                $0.value = Color.Background.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.Separator.toImage(size: CGSize(width: 20, height: 20))
                })
        return section
    }
    
    func generateNavigationColor() -> Section {
        let section = Section()
        section
            <<< TextRow(kColorFormNBC) {
                $0.title = "NavigationBarColor"
                $0.value = Color.NavigationBackground.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.NavigationBackground.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow(kColorFormNTC) {
                $0.title = "NavigationTextColor"
                $0.value = Color.NavigationText.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.NavigationText.toImage(size: CGSize(width: 20, height: 20))
                })
        return section
    }
    
    func generateTabColor() -> Section {
        let section = Section()
        section
            <<< TextRow(kColorFormTBC) {
                $0.title = "TabBarColor"
                $0.value = Color.TabBackground.hexRGB
            }.cellUpdate({ (cell, row) -> () in
                cell.imageView?.image = Color.TabBackground.toImage(size: CGSize(width: 20, height: 20))
            })
            <<< TextRow(kColorFormTBSC) {
                $0.title = "TabBarSelectedColor"
                $0.value = Color.TabItemSelected.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.TabItemSelected.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow(kColorFormTBUC) {
                $0.title = "TabBarUnselectedColor"
                $0.value = Color.TabItemUnselected.hexRGB
        }
        return section
    }
    
    func generateConnectButtonColor() -> Section {
        let section = Section()
        section
            <<< TextRow(kColorFormCBC) {
                $0.title = "ConnectButtonConnectedColor"
                $0.value = Color.StatusOn.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.StatusOn.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow(kColorFormCBD) {
                $0.title = "ConnectButtonDisconnectedColor"
                $0.value = Color.StatusOff.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.StatusOff.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow() {
                $0.title = "ConnectButtonConnectingColor"
        }
        return section
    }
    
    func generateButtonColor() -> Section {
        let section = Section()
        section
            <<< TextRow(kColorFormBIC) {
                $0.title = "ButtonIconColor"
                $0.value = Color.ButtonIcon.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.ButtonIcon.toImage(size: CGSize(width: 20, height: 20))
                })
        return section
    }
    
    func generatePingColor() -> Section {
        let section = Section()
        section
            <<< TextRow() {
                $0.title = "PingSuccessTextColor"
                $0.value = Color.PingSuccessText.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.PingSuccessText.toImage(size: CGSize(width: 20, height: 20))
                })
            <<< TextRow() {
                $0.title = "PingTimeOutTextColor"
                $0.value = Color.PingTimeoutText.hexRGB
                }.cellUpdate({ (cell, row) -> () in
                    cell.imageView?.image = Color.PingTimeoutText.toImage(size: CGSize(width: 20, height: 20))
                })
        return section
    }
    
    @objc func save() {
        do {
            let values = form.values()
            let BC = values[kColorFormBC] as? String
            let SC = values[kColorFormSC] as? String
            let NBC = values[kColorFormNBC] as? String
            let NTC = values[kColorFormNTC] as? String
            let TBC = values[kColorFormTBC] as? String
            let TBSC = values[kColorFormTBSC] as? String
            let TBUC = values[kColorFormTBUC] as? String
            let CBC = values[kColorFormCBC] as? String
            let CBD = values[kColorFormCBD] as? String
            let BIC = values[kColorFormBIC] as? String
            Color.Brand = BC!.color
            Color.Separator = SC!.color
            Color.NavigationBackground  = NBC!.color
            Color.NavigationText = NTC!.color
            Color.TabBackground = TBC!.color
            Color.TabItemSelected = TBSC!.color
            Color.TabItemUnselected = TBUC!.color
            Color.StatusOn = CBC!.color
            Color.StatusOff = CBD!.color
            Color.ButtonIcon = BIC!.color
            let UM = UIManager()
            UM.reloadAll()
        }
    }
}
