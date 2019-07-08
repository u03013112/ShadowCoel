//
//  QRCodeViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/26.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import Eureka
import EFQRCode

class CustomUIImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 340, height: 340)
    }
    
}

class QRCodeViewController: FormViewController {
    
    var url: String
    var image: UIImage? = nil
    
    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init()
    }
    
    init(url: String? = nil) {
        self.url = url!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "QR Code".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(onshare))
        generateQRCode()
        generateQRCodeForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func generateQRCode() {
        if let tryImage = EFQRCode.generate(
            content: url,
            watermark: UIImage(named: "ShadowCoel")?.toCGImage()
            ) {
            print("Create QRCode image success: \(tryImage)")
            self.image = UIImage(cgImage: tryImage)
        } else {
            print("Create QRCode image failed!")
        }
    }
    
    @objc func onshare() {
        var objectsToShare = [AnyObject]()
         objectsToShare.append(self.image!)
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func generateQRCodeForm() {
        // Thanks stackoverflow.com/questions/26180822/how-to-add-constraints-programmatically-using-swift
        let newView = CustomUIImageView()
        newView.image = self.image
        view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = newView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = newView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
