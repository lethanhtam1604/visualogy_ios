//
//  HexColor.swift
//  HexColor
//
//  Created by Tuomas Artman on 1.9.2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    public convenience init(_ value: Int) {
        let components = getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
    
    public convenience init(_ value: Int, alpha: CGFloat) {
        let components = getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
    
    public func alpha(value:CGFloat) -> UIKit.UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIKit.UIColor(red: red, green: green, blue: blue, alpha: value)
    }
    
    /// Mixes the color with another color
    ///
    /// - parameter color: The color to mix with
    /// - parameter amount: The amount (0-1) to mix the new color in.
    /// - returns: A new UIColor instance representing the resulting color
    public func mixWithColor(color:UIColor, amount:Float) -> UIColor {
        var comp1: [CGFloat] = Array(count: 4, repeatedValue: 0);
        self.getRed(&comp1[0], green: &comp1[1], blue: &comp1[2], alpha: &comp1[3])
        
        var comp2: [CGFloat] = Array(count: 4, repeatedValue: 0);
        color.getRed(&comp2[0], green: &comp2[1], blue: &comp2[2], alpha: &comp2[3])
        
        var comp: [CGFloat] = Array(count: 4, repeatedValue: 0);
        for i in 0...3 {
            comp[i] = comp1[i] + (comp2[i] - comp1[i]) * CGFloat(amount)
        }
        
        return UIColor(red:comp[0], green: comp[1], blue: comp[2], alpha: comp[3])
    }
}

private func getColorComponents(value: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let r = CGFloat(value >> 16 & 0xFF) / 255.0
    let g = CGFloat(value >> 8 & 0xFF) / 255.0
    let b = CGFloat(value & 0xFF) / 255.0
    
    return (r, g, b)
}
