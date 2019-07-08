//
//  SubscribeRow.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/29.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import ShadowCoelModel
import Eureka
import Cartography

/*
 final class ProxyRow: Row<Proxy, ProxyRowCell>, RowType {
 
 required init(tag: String?) {
 super.init(tag: tag)
 displayValueFor = nil
 }
 }
 */

class _SubscribeRow: Row<SubscribeRowCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

final class SubscribeRow: _SubscribeRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil // 不重复显示
    }
}

class SubscribeRowCell: Cell<Subscribe>, CellType {
    
    let group = ConstraintGroup()
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
    }
    
    override func update() {
        super.update()
        if let subscribe = row.value {
            titleLabel.text = subscribe.name
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: "Server")
        }
        if row.isDisabled {
            titleLabel.textColor = "5F5F5F".color
        }else {
            titleLabel.textColor = "000".color
        }
        constrain(titleLabel, iconImageView, contentView, replace: group) { titleLabel, iconImageView, contentView in
            iconImageView.leading == contentView.leading + 16
            iconImageView.width == 24
            iconImageView.height == 24
            iconImageView.centerY == contentView.centerY
            titleLabel.centerY == iconImageView.centerY
            titleLabel.leading == iconImageView.trailing + 10
            titleLabel.trailing == contentView.trailing - 16
            titleLabel.bottom == contentView.bottom - 16
        }
    }
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 17)
        return v
    }()
    
    lazy var iconImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
}

