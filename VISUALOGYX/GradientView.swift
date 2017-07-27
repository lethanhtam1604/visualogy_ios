//
//  GradientView.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import PureLayout

public class GradientView: UIView {
    private let gradientBackground = CAGradientLayer()

    var autoFit = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public init() {
        super.init(frame: CGRectZero)
        self.commonInit()
    }
    
    public init(autoFit: Bool) {
        super.init(frame: CGRectZero)
        self.commonInit()
        self.autoFit = autoFit
    }
    
    func commonInit() {
        gradientBackground.colors = [Global.colorMain.CGColor, Global.colorSecond.CGColor]
        gradientBackground.startPoint = CGPointMake(0.0, 0.5)
        gradientBackground.endPoint = CGPointMake(1.0, 0.5)
        
        layer.addSublayer(gradientBackground)
        
        userInteractionEnabled = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientBackground.frame = bounds
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        if autoFit {
            if superview != nil {
                self.autoPinEdgesToSuperviewEdges()
            }
        }
    }
}
