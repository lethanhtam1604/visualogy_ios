//
//  PasswordViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/8/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import SwiftOverlays
import FontAwesomeKit

class PasswordViewController: UIViewController, UITextFieldDelegate {
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let errorLabel = UILabel()
    let emailField = UITextField()
    let emailBorder = UIView()
    let submitButton = UIButton()
    let newUserButton = UIButton()
    
    var constraintsAdded = false

    var email : String? {
        didSet {
            emailField.text = email
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forgot Password"
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.tintColor = Global.colorSecond
        self.view.addTapToDismiss()
        
        errorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        errorLabel.textAlignment = .Center
        errorLabel.textColor = UIColor.redColor().alpha(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true

        emailField.placeholder = "Email"
        emailField.delegate = self
        emailField.textColor = Global.colorSecond
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .Done
        emailField.keyboardType = .EmailAddress
        emailField.autocorrectionType = .No
        emailField.autocapitalizationType = .None

        emailBorder.backgroundColor = Global.colorBg
        
        submitButton.setTitle("Send a new password", forState: .Normal)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        submitButton.insertSubview(GradientView(autoFit: true), atIndex: 0)
        submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        newUserButton.setTitle("New User?", forState: .Normal)
        newUserButton.setTitleColor(Global.colorSelected, forState: .Normal)
        newUserButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        newUserButton.addTarget(self, action: #selector(signUp), forControlEvents: .TouchUpInside)
        newUserButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        newUserButton.sizeToFit()
        
        containerView.addSubview(errorLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(submitButton)
        containerView.addSubview(newUserButton)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            errorLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            errorLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            errorLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            errorLabel.autoSetDimension(.Height, toSize: 20)

            emailField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            emailField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            emailField.autoPinEdge(.Top, toEdge: .Bottom, ofView: errorLabel, withOffset: 1)
            emailField.autoSetDimension(.Height, toSize: 40)
            
            emailBorder.autoPinEdgeToSuperviewEdge(.Left)
            emailBorder.autoPinEdgeToSuperviewEdge(.Right)
            emailBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            emailBorder.autoSetDimension(.Height, toSize: 1)
            
            submitButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            submitButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            submitButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailField, withOffset: 20)
            submitButton.autoSetDimension(.Height, toSize: 50)
            
            newUserButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: submitButton, withOffset: 10)
            newUserButton.autoAlignAxisToSuperviewAxis(.Vertical)
            newUserButton.autoSetDimensionsToSize(newUserButton.frame.size)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 300
        containerView.frame = CGRectMake(0, 0, view.frame.width, height)
        scrollView.contentSize = containerView.bounds.size
    }
    
    
    func submit() {
        if !checkInput(emailField, value: emailField.text) {
            return
        }
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue(), {
            SwiftOverlays.removeAllBlockingOverlays()
            let successIcon = FAKFontAwesome.sendIconWithSize(20)
            successIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            let successImg = successIcon.imageWithSize(CGSizeMake(20, 20))
            SwiftOverlays.showBlockingImageAndTextOverlay(successImg!, text: "Email sent")

            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue(), {
                SwiftOverlays.removeAllBlockingOverlays()
                self.navigationController?.popViewControllerAnimated(true)
            })
        })
    }
    
    func signUp() {
        var controllers = self.navigationController!.viewControllers
        controllers.removeLast()
        controllers.append(SignUpViewController())
        self.navigationController!.setViewControllers(controllers, animated: true)
    }
    
    // delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).stringByReplacingCharactersInRange(range, withString: string)
        checkInput(textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if checkInput(textField, value: textField.text) {
            textField.resignFirstResponder()
            submit()
            return true
        }
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        if value != nil && value!.isValidEmail() {
            errorLabel.text = nil
            textField.subviews.last?.backgroundColor = Global.colorBg
            return true
        }
        
        errorLabel.text = "Invalid email address"
        textField.subviews.last?.backgroundColor = UIColor.redColor().alpha(0.8)
        return false
    }
}
