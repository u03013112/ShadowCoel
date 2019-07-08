//
//  HttpRequestVC.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/20.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import Eureka

class HttpRequestVC: FormViewController {
    
    let request: Request
    
    init(request: Request) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleRefreshUI()
    }
    
    func handleRefreshUI() {
        updateForm()
    }
    
    func updateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateRequestLine()
        form +++ generateRequestHeaders()
        form.delegate = self
        tableView.reloadData()
    }
    
    func generateRequestLine() -> Section {
        let section = Section("REQUEST LINE")
        section
            <<< LabelRow() {
                $0.title = request.method.description + " " + request.path + " " + request.version!
        }
        return section
    }
    
    func generateRequestHeaders() -> Section{
        let section = Section("REQUEST HEADERS")
        section
            <<< LabelRow() {
                $0.title = request.headers
        }
        return section
    }
}
