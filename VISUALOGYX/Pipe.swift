//
//  CircleView.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/4/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

enum PipeType {
    case Detected
    case Added
    case Removed
    
    case Square
    case Triangle
    case Circle
    
    var image : UIImage {
        switch self {
        case .Detected:
            return UIImage(named: "detect.png")!
        case .Added:
            return UIImage(named: "add_1.png")!
        case .Removed:
            return UIImage(named: "subtract_1.png")!
        case .Square:
            return UIImage(named: "square.png")!
        case .Circle:
            return UIImage(named: "circle.png")!
        case .Triangle:
            return UIImage(named: "triangle.png")!
        }
    }
}

class Pipe {
    
    var id = -1
    
    var x : CGFloat {
        return center.x
    }
    
    var y : CGFloat {
        return center.y
    }
    
    var frame : CGRect {
        return CGRectMake(x - radius, y - radius, radius * 2, radius * 2)
    }
    
    var center : CGPoint = CGPointZero
    var radius : CGFloat = 0
    var type : PipeType = .Detected

    convenience init(x: CGFloat, y: CGFloat, radius: CGFloat, type: PipeType) {
        self.init(center: CGPointMake(x, y), radius: radius, type: type)
    }
    
    init(center: CGPoint, radius: CGFloat, type: PipeType) {
        self.center = center
        self.radius = radius
        self.type = type
    }
    
    convenience init() {
        self.init(center: CGPointZero, radius: 0, type: .Added)
    }
    
}
