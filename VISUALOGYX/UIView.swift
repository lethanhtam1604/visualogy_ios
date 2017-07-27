//
//  ViewShot.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/5/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import QuartzCore

let tagBorderBottom = 10

extension UIView {
    // shot
    
    func snapshot() -> UIImage {
        let size = self.frame.size
        let rect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContext(size)
        drawViewHierarchyInRect(rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    // keyboard
    
    func addTapToDismiss() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    func dismiss() {
        endEditing(true)
    }
}
