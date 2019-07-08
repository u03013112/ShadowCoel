//
//  IconViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/9.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation


class IconViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Icon"
        self.tabBarController?.tabBar.barTintColor = Color.TabBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
 
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateShadowCoelIcons()
        form +++ generatePretendIcons()
        form.delegate = self
        tableView.reloadData()
    }
    
    func generateShadowCoelIcons() -> Section {
        let section = Section("ShadowCoel")
        section
            <<< ActionRow() {
                $0.title = "Change to ShadowCoel(blue -> Purple)"
            }.onCellSelection({ [unowned self](cell, row) -> () in
                if #available(iOS 10.3, *) {
                    self.changetoBluePurple()
                } else {
                    // Fallback on earlier versions
                }
            })
            <<< ActionRow() {
                $0.title = "Change to ShadowCoel(Water)"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    if #available(iOS 10.3, *) {
                        self.changetoWater()
                    } else {
                        // Fallback on earlier versions
                    }
                })
            <<< ActionRow(){
                $0.title = "Change to ShadowCoel(Gold)"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    if #available(iOS 10.3, *) {
                        self.changetoGold()
                    } else {
                        // Fallback on earlier versions
                    }
                })
        return section
    }
    
    func generatePretendIcons() -> Section {
        let section = Section("Pretend")
        section
            <<< ActionRow() {
                $0.title = "Pretend to be KuaiShou"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    if #available(iOS 10.3, *) {
                        self.changetoKuaiShou()
                    } else {
                        // Fallback on earlier versions
                    }
                })
            <<< ActionRow() {
                $0.title = "Pretend to be TikTok"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    if #available(iOS 10.3, *) {
                        self.changetoTikTok()
                    } else {
                        // Fallback on earlier versions
                    }
                })
            <<< ActionRow() {
                $0.title = "Pretend to be JinRiTouTiao"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    if #available(iOS 10.3, *) {
                        self.changetoJinRiTouTiao()
                    } else {
                        // Fallback on earlier versions
                    }
                })
            <<< ActionRow() {
                $0.title = "Pretend to be TiLu12306"
                }.onCellSelection({ [unowned self](cell, row) -> () in
                    if #available(iOS 10.3, *) {
                        self.changetoJinRiTouTiao()
                    } else {
                        // Fallback on earlier versions
                    }
                })
        return section
    }
    
    @available(iOS 10.3, *)
    func changetoBluePurple() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "ShadowCoel-BluePurple"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => BluePurple")
                }
            })
        }
    }
    
    @available(iOS 10.3, *)
    func changetoWater() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "ShadowCoel-Water"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => Water")
                }
            })
        }
    }
    
    @available(iOS 10.3, *)
    func changetoGold() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "ShadowCoel-Gold"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => Gold")
                }
            })
        }
    }
    
    @available(iOS 10.3, *)
    func changetoKuaiShou() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "KuaiShou"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => KuaiShou")
                }
            })
        }
    }
    
    @available(iOS 10.3, *)
    func changetoTikTok() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "TikTok"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => Tiktok")
                }
            })
        }
    }
    
    @available(iOS 10.3, *)
    func changetoJinRiTouTiao() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "JinRiTouTiao"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => JinRiTouTiao")
                }
            })
        }
    }
    
    @available(iOS 10.3, *)
    func changetoTiLu12306() {
        let app = UIApplication.shared
        if app.supportsAlternateIcons {
            let icon = "TiLu12306"
            app.setAlternateIconName(icon, completionHandler: { (error) in
                if error != nil {
                    DDLogError("error => \(String(describing: error?.localizedDescription))")
                }else {
                    DDLogInfo("Icon change => TiLu12306")
                }
            })
        }
    }
    
}

