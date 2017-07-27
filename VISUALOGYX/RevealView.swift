//
//  RevealView.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/6/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

public protocol RevealViewDelegate {
    func revealViewSelectionDidChange(revealView: RevealView, index: Int, view: UIView)
    func revealViewDidShow()
    func revealViewDidHide()
}

public class RevealView: UIView {
    private var anchorConstraintsAdded = true
    private var viewContraintsAdded = true
    private var anchorWidthConstraint : NSLayoutConstraint?
    private var anchorHeightConstraint : NSLayoutConstraint?
    private var anchorTopConstraint : NSLayoutConstraint?
    private var anchorLeftConstraint : NSLayoutConstraint?
    private var viewConstraints : [NSLayoutConstraint]!
    
    private var _anchorView : UIView?
    private var _views : [UIView]?
    
    public var anchorView : UIView! {
        set(newValue) {
            updateAnchorView(newValue)
        }
        get {
            return _anchorView
        }
    }
    
    public var showing = false
    
    public var views : [UIView]! {
        set(newValue) {
            updateViews(newValue)
        }
        get {
            return _views
        }
    }
    
    var delegate : RevealViewDelegate?
    
    public init() {
        super.init(frame: CGRectZero)
        self.commonInit()
    }
    
    public  required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
    }
    
    
    func updateAnchorView(newValue: UIView) {
        if let top = anchorTopConstraint {
            _anchorView?.removeConstraint(top)
        }
        if let left = anchorLeftConstraint {
            _anchorView?.removeConstraint(left)
        }
        if let width = anchorWidthConstraint {
            _anchorView?.removeConstraint(width)
        }
        if let height = anchorHeightConstraint {
            _anchorView?.removeConstraint(height)
        }
        
        _anchorView = newValue
        
        anchorConstraintsAdded = false
        self.setNeedsUpdateConstraints()
    }
    
    func updateViews(newValue: [UIView]) {
        if let _views = _views {
            for view in _views {
                view.removeFromSuperview()
            }
        }
        
        _views = newValue
        
        for view in newValue {
            view.hidden = true
            view.userInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectView)))
            addSubview(view)
        }
        
        viewContraintsAdded = false
        self.setNeedsUpdateConstraints()
    }
    
    public override func updateConstraints() {
        if !viewContraintsAdded {
            if _anchorView == nil {
                return
            }
            
            viewContraintsAdded = true
            
            viewConstraints = [NSLayoutConstraint]()
            
            for view in subviews {
                view.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
                view.autoMatchDimension(.Height, toDimension: .Height, ofView: _anchorView!)
                view.autoPinEdge(.Left, toEdge: .Left, ofView: self)

                let top = view.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
                viewConstraints.append(top)
            }
        }
        
        if !anchorConstraintsAdded {
            anchorConstraintsAdded = true
            
            anchorWidthConstraint = self.autoMatchDimension(.Width, toDimension: .Width, ofView: _anchorView!)
            anchorHeightConstraint = self.autoMatchDimension(.Height, toDimension: .Height, ofView: _anchorView!)
            anchorTopConstraint = self.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: _anchorView!)
            anchorLeftConstraint = self.autoPinEdge(.Leading, toEdge: .Leading, ofView: _anchorView!)
        }
        
        anchorHeightConstraint = anchorHeightConstraint?.setMultiplier(CGFloat(subviews.count + 1))
        
        super.updateConstraints()
    }
    
    func selectView(touch: UITapGestureRecognizer) {
        for i in 0..<subviews.count {
            let subview = subviews[i]
            if subview == touch.view {
                delegate?.revealViewSelectionDidChange(self, index: i, view: subview)
                hide()
            }
        }
    }
    
    public func show() {
        if showing {
            return
        } else {
            showAt(subviews.count - 1)
        }
    }
    
    private func showAt(index: Int) {
        if index < 0 {
            showing = true
            return
        }
        
        let constraint = viewConstraints[index]
        constraint.constant = -CGFloat(viewConstraints.count - index) * anchorView!.frame.size.height
        let view = subviews[index]
        view.alpha = 0
        view.hidden = false
        UIView.animateWithDuration(0.15, animations: {
            self.layoutIfNeeded()
            view.alpha = 1
            }, completion: {
                _ in
                self.showAt(index - 1)
        })
    }
    
    public func hide() {
        if showing {
            hideAt(0)
        }
    }
    
    private func hideAt(index: Int) {
        if index >= viewConstraints.count {
            showing = false
            return
        }
        
        let constraint = viewConstraints[index]
        constraint.constant = 0
        let view = subviews[index]
        UIView.animateWithDuration(0.15, animations: {
            self.layoutIfNeeded()
            view.alpha = 0
            }, completion: {
                _ in
                view.hidden = true
                self.hideAt(index + 1)
        })
    }
}
