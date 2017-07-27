//
//  StackView.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/6/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class StackView: UIView {

    var space : CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let width = (frame.width - CGFloat(subviews.count - 1) * space) / CGFloat(subviews.count)
        var subFrame = CGRectMake(0, 0, width, frame.height)
        for view in subviews {
            view.frame = subFrame
            subFrame = CGRectOffset(subFrame, width + space, 0)
        }
    }
}
