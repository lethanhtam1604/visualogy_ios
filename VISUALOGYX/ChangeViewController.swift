//
//  ChangeViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/6/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit

class ChangeViewController: UIViewController {
    let backgroundView = UIView()
    let anchorImage = UIImageView()
    let anchorUp = UIImageView()
    let anchorDown = UIImageView()
    let changeView = UIView()
    
    let copyButton = UIButton()
//    let editButton = UIButton()
    let deleteButton = UIButton()
    
    
    var constraintsAdded = false
    
    var topConstraint : NSLayoutConstraint!
    var bottomConstraint : NSLayoutConstraint!
    
    var marginTopConstraint : NSLayoutConstraint!
    var marginLeftConstraint : NSLayoutConstraint!
    var heightConstraint : NSLayoutConstraint!
    var widthConstraint : NSLayoutConstraint!
    
    var anchorView : UIView!
    var inspection : Inspection!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeView.addSubview(copyButton)
  //      changeView.addSubview(editButton)
        changeView.addSubview(deleteButton)
        
        view.addSubview(backgroundView)
        view.addSubview(anchorImage)
        view.addSubview(anchorUp)
        view.addSubview(anchorDown)
        view.addSubview(changeView)
        
        backgroundView.backgroundColor = UIColor.blackColor().alpha(0.8)
        backgroundView.userInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
        let iconUp = FAKFontAwesome.caretUpIconWithSize(25)
        iconUp.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        anchorUp.image = iconUp.imageWithSize(CGSizeMake(25, 25))
        
        let iconDown = FAKFontAwesome.caretDownIconWithSize(25)
        iconDown.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        anchorDown.image = iconDown.imageWithSize(CGSizeMake(25, 25))
        
        changeView.backgroundColor = UIColor.whiteColor()
        changeView.clipsToBounds = true
        changeView.layer.cornerRadius = 3

        let copy = FAKFontAwesome.copyIconWithSize(40)
        copy.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
        copyButton.setImage(copy.imageWithSize(CGSizeMake(40, 40)), forState: .Normal)
        copyButton.imageView?.contentMode = .ScaleAspectFit
        copyButton.addTarget(self, action: #selector(copyInspection), forControlEvents: .TouchUpInside)
        
//        let edit = FAKFontAwesome.editIconWithSize(40)
//        edit.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
//        editButton.setImage(edit.imageWithSize(CGSizeMake(40, 40)), forState: .Normal)
//        editButton.imageView?.contentMode = .ScaleAspectFit
//        editButton.addTarget(self, action: #selector(editInspection), forControlEvents: .TouchUpInside)
        
        let delete = FAKFontAwesome.removeIconWithSize(40)
        delete.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
        deleteButton.setImage(delete.imageWithSize(CGSizeMake(40, 40)), forState: .Normal)
        deleteButton.imageView?.contentMode = .ScaleAspectFit
        deleteButton.addTarget(self, action: #selector(deleteInspection), forControlEvents: .TouchUpInside)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            backgroundView.autoPinEdgesToSuperviewEdges()
            
            marginTopConstraint = anchorImage.autoPinEdgeToSuperviewEdge(.Top)
            marginLeftConstraint = anchorImage.autoPinEdgeToSuperviewEdge(.Left)
            widthConstraint = anchorImage.autoSetDimension(.Width, toSize: 30)
            heightConstraint = anchorImage.autoSetDimension(.Height, toSize: 30)
            
            bottomConstraint = changeView.autoPinEdge(.Top, toEdge: .Bottom, ofView: anchorImage, withOffset: 10)
            topConstraint = changeView.autoPinEdge(.Bottom, toEdge: .Top, ofView: anchorImage, withOffset: -10)
            
            changeView.autoSetDimension(.Height, toSize: 80)
            changeView.autoMatchDimension(.Width, toDimension: .Width, ofView: view, withOffset: -20)
            changeView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: anchorImage)
            
            anchorUp.autoSetDimensionsToSize(CGSizeMake(25, 25))
            anchorUp.autoPinEdge(.Bottom, toEdge: .Top, ofView: changeView, withOffset: 10)
            anchorUp.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: changeView, withOffset: -10)
            
            anchorDown.autoSetDimensionsToSize(CGSizeMake(25, 25))
            anchorDown.autoPinEdge(.Top, toEdge: .Bottom, ofView: changeView, withOffset: -10)
            anchorDown.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: changeView, withOffset: -10)
            
            copyButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
            copyButton.autoAlignAxisToSuperviewAxis(.Horizontal)
            copyButton.autoAlignAxis(.Vertical, toSameAxisOfView: changeView, withOffset: -30)
            
//            editButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
//            editButton.autoAlignAxisToSuperviewAxis(.Horizontal)
//            editButton.autoAlignAxis(.Vertical, toSameAxisOfView: changeView, withOffset: 0)
            
            deleteButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
            deleteButton.autoAlignAxisToSuperviewAxis(.Horizontal)
            deleteButton.autoAlignAxis(.Vertical, toSameAxisOfView: changeView, withOffset: 30)
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update views
        let shot = anchorView.snapshot()
        anchorImage.image = shot
        
        let anchorFrame = view.convertRect(anchorView.frame, fromView: anchorView.superview)
        
        widthConstraint.constant = anchorFrame.width
        heightConstraint.constant = anchorFrame.height
        
        marginLeftConstraint.constant = anchorFrame.origin.x
        marginTopConstraint.constant = anchorFrame.origin.y
        
        if marginTopConstraint.constant > view.frame.size.height - 70 {
            topConstraint.active = true
            bottomConstraint.active = false
            
            anchorUp.hidden = true
            anchorDown.hidden = false
        } else {
            topConstraint.active = false
            bottomConstraint.active = true
            
            anchorUp.hidden = false
            anchorDown.hidden = true
        }
    }
    
    func hide() {
        self.willMoveToParentViewController(nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 0
            }, completion: {
                _ in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    
    // action
    
    func copyInspection() {
        let requestController = RequestViewController()
        requestController.request = .Copy
        requestController.inspection = inspection
        self.navigationController?.pushViewController(requestController, animated: true)
    }
    
    func editInspection() {
        let requestController = RequestViewController()
        requestController.request = .Edit
        requestController.inspection = inspection
        self.navigationController?.pushViewController(requestController, animated: true)
    }
    
    func deleteInspection() {
        let alert = UIAlertController(title: "Confirm",
                                      message: "Do you want to delete this request?",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            _ in
            // TODO: remove request
            
            self.hide()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
