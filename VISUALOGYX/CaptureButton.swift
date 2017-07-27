//
//  CaptureButton.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 9/23/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import QuartzCore

public protocol CaptureButtonDelegate {
    func shouldTakePicture()
    func shouldCaptureVideo()
    func shouldStopCapturingVideo()
}

public class CaptureButton: UIView {
    private var constraintsAdded = false
    private let innerButton = UIButton()
    private var captureTimer : NSTimer?
    private var holding = false
    private var capturing = false

    private var constraintsLeft   : NSLayoutConstraint!
    private var constraintsRight  : NSLayoutConstraint!
    private var constraintsTop    : NSLayoutConstraint!
    private var constraintsBottom : NSLayoutConstraint!
    
    public var shadowOffset = CGSizeZero {
        didSet {
            self.layer.shadowOffset = shadowOffset
            innerButton.layer.shadowOffset = shadowOffset
        }
    }
    
    public var icon : UIImage? {
        didSet {
            self.innerButton.setImage(icon, forState: .Normal)
        }
    }
    
    public var enabled = false {
        didSet {
            self.innerButton.enabled = enabled
        }
    }
    
    public var delegate : CaptureButtonDelegate?

    
    public init() {
        super.init(frame: CGRectZero)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.whiteColor().alpha(0.8)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.addSubview(innerButton)
 
        innerButton.backgroundColor = UIColor.whiteColor()
        innerButton.layer.shadowColor = UIColor.blackColor().CGColor
        innerButton.layer.shadowRadius = 3
        innerButton.layer.shadowOpacity = 0.8
        
        innerButton.addTarget(self, action: #selector(touchDown), forControlEvents: .TouchDown)
        innerButton.addTarget(self, action: #selector(touchUp), forControlEvents: .TouchUpInside)
        innerButton.addTarget(self, action: #selector(touchUp), forControlEvents: .TouchUpOutside)
    }
    
    public override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            constraintsLeft   = innerButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            constraintsRight  = innerButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            constraintsTop    = innerButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            constraintsBottom = innerButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        }
        super.updateConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2
        innerButton.layer.cornerRadius = (frame.size.width - 2 * constraintsLeft.constant) / 2
    }
    
    
    func touchDown() {
        holding = true
        innerButton.backgroundColor = UIColor.redColor()
        captureTimer?.invalidate()
        captureTimer = NSTimer.scheduledTimerWithTimeInterval(0.3,
                                                              target: self,
                                                              selector: #selector(capture),
                                                              userInfo: nil,
                                                              repeats: false)
    }
    
    func touchUp() {
        if capturing {
            capturing = false
            
            constraintsLeft.constant = 10
            constraintsRight.constant = -10
            constraintsTop.constant = 10
            constraintsBottom.constant = -10
            
            UIView.animateWithDuration(0.3, animations: {
                self.setNeedsUpdateConstraints()
            })
            
            delegate?.shouldStopCapturingVideo()
        }
        holding = false
        innerButton.backgroundColor = UIColor.whiteColor()
    }
    
    func capture() {
        if holding {
            capturing = true

            constraintsLeft.constant = 0
            constraintsRight.constant = 0
            constraintsTop.constant = 0
            constraintsBottom.constant = 0
            
            UIView.animateWithDuration(0.3, animations: {
                self.setNeedsUpdateConstraints()
            })
            
            delegate?.shouldCaptureVideo()
        } else {
            delegate?.shouldTakePicture()
        }
    }
}