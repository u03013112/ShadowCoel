//
//  ColorExtension.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/9.
//  Copyright © 2019 CoelWu. All rights reserved.
//
//  Come from stackoverflow.com/questions/28696862/what-is-the-best-shortest-way-to-convert-a-uicolor-to-hex-web-color-in-swift

extension UIColor {
    typealias RGBComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    typealias HSBComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    var rgbComponents:RGBComponents {
        var c:RGBComponents = (0,0,0,0)
        
        if getRed(&c.red, green: &c.green, blue: &c.blue, alpha: &c.alpha) {
            return c
        }
        
        return (0,0,0,0)
    }
    
    var cssRGBA:String {
        return String(format: "rgba(%d,%d,%d, %.02f)", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255), Int(rgbComponents.blue * 255), Float(rgbComponents.alpha))
    }
    var hexRGB:String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255), Int(rgbComponents.blue * 255)).uppercased()
    }
    var hexRGBA:String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255), Int(rgbComponents.blue * 255), Int(rgbComponents.alpha * 255) ).uppercased()
    }
    
    var hsbComponents:HSBComponents {
        var c:HSBComponents = (0,0,0,0)
        
        if getHue(&c.hue, saturation: &c.saturation, brightness: &c.brightness, alpha: &c.alpha) {
            return c
        }
        
        return (0,0,0,0)
    }
}
