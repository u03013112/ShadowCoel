//
//  Diagnostics.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/18.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Eureka
import Foundation

class DiagnosticsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Diagnostics".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form.delegate = self
        tableView.reloadData()
    }
    

}
