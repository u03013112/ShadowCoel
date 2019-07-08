//
//  ColorManager.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/10.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation

class ColorManager {
    
    open func resetColor() {
        Color.Brand = Color.Black
        Color.Separator = "E0E0E0".color
        Color.Background = "F9F9F9".color
        
        Color.NavigationBackground = "FFFFFF".color
        Color.NavigationText = "333333".color
        
        Color.TabBackground = "FFFFFF".color
        Color.TabItemSelected = "000".color
        Color.TabItemUnselected = "D7D7D7".color
        
        Color.StatusOn = "FF5E3B".color
        Color.StatusOff = "1E96E2".color
        Color.StatusConnecting = "F5A623".color
        
        Color.PingSuccessText = "45995E".color
        Color.PingTimeoutText = "CF5747".color
        
        let UM = UIManager()
        UM.reloadAll()
    }
    
    open func generateUri() {
        
    }
}
