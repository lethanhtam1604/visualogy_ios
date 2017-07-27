//
//  SignupViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/8/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import PasswordTextField
import FontAwesomeKit
import SwiftOverlays

class SignUpViewController: UIViewController, UITextFieldDelegate {
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let facebookButton = UIButton()
    let googleButton = UIButton()
    let orLabel = UILabel()
    let errorLabel = UILabel()
    let nameField = UITextField()
    let nameBorder = UIView()
    let emailField = UITextField()
    let emailBorder = UIView()
    let phoneField = UITextField()
    let phoneBorder = UIView()
    let passwordField = PasswordTextField()
    let passwordBorder = UIView()
    let confirmField = PasswordTextField()
    let confirmBorder = UIView()
    let signUpButton = UIButton()
    let userButton = UIButton()
    
    var constraintsAdded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.tintColor = Global.colorSecond
        self.view.addTapToDismiss()
        
        let facebookIcon = FAKFoundationIcons.socialFacebookIconWithSize(30)
        facebookIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        facebookButton.setImage(facebookIcon.imageWithSize(CGSizeMake(30, 30)), forState: .Normal)
        facebookIcon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
        facebookButton.setImage(facebookIcon.imageWithSize(CGSizeMake(30, 30)), forState: .Highlighted)
        facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        facebookButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        facebookButton.setTitle("Facebook", forState: .Normal)
        facebookButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        facebookButton.addTarget(self, action: #selector(loginFacebook), forControlEvents: .TouchUpInside)
        facebookButton.backgroundColor = Global.colorFacebook
        facebookButton.layer.cornerRadius = 5
        facebookButton.clipsToBounds = true
        
        let googleIcon = FAKFoundationIcons.socialGooglePlusIconWithSize(30)
        googleIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        googleButton.setImage(googleIcon.imageWithSize(CGSizeMake(30, 30)), forState: .Normal)
        googleIcon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
        googleButton.setImage(googleIcon.imageWithSize(CGSizeMake(30, 30)), forState: .Highlighted)
        googleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        googleButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        googleButton.setTitle("Google", forState: .Normal)
        googleButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        googleButton.addTarget(self, action: #selector(loginGoogle), forControlEvents: .TouchUpInside)
        googleButton.backgroundColor = Global.colorGoogle
        googleButton.layer.cornerRadius = 5
        googleButton.clipsToBounds = true
        
        orLabel.text = "OR"
        orLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        orLabel.textAlignment = .Center
        orLabel.textColor = Global.colorSelected
        orLabel.adjustsFontSizeToFitWidth = true
        
        errorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        errorLabel.textAlignment = .Center
        errorLabel.textColor = UIColor.redColor().alpha(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        nameField.placeholder = "Name"
        nameField.delegate = self
        nameField.textColor = Global.colorSecond
        nameField.addSubview(nameBorder)
        nameField.returnKeyType = .Next
        nameField.keyboardType = .NamePhonePad
        nameField.inputAccessoryView = UIView()
        nameField.autocapitalizationType = .Words
        
        nameBorder.backgroundColor = Global.colorBg
        
        emailField.placeholder = "Email"
        emailField.delegate = self
        emailField.textColor = Global.colorSecond
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .Next
        emailField.keyboardType = .EmailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .No
        emailField.autocapitalizationType = .None

        
        emailBorder.backgroundColor = Global.colorBg
        
        phoneField.placeholder = "Phone number"
        phoneField.delegate = self
        phoneField.textColor = Global.colorSecond
        phoneField.addSubview(phoneBorder)
        phoneField.returnKeyType = .Next
        phoneField.keyboardType = .PhonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .No
        phoneField.autocapitalizationType = .None
        
        phoneBorder.backgroundColor = Global.colorBg
        
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.textColor = Global.colorSecond
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .Next
        passwordField.keyboardType = .ASCIICapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .No
        passwordField.autocapitalizationType = .None
       
        passwordBorder.backgroundColor = Global.colorBg
        
        confirmField.placeholder = "Confirm Password"
        confirmField.delegate = self
        confirmField.textColor = Global.colorSecond
        confirmField.addSubview(confirmBorder)
        confirmField.returnKeyType = .Done
        confirmField.keyboardType = .ASCIICapable
        confirmField.inputAccessoryView = UIView()
        confirmField.autocorrectionType = .No
        confirmField.autocapitalizationType = .None

        confirmBorder.backgroundColor = Global.colorBg
        
        
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        signUpButton.insertSubview(GradientView(autoFit: true), atIndex: 0)
        signUpButton.addTarget(self, action: #selector(signUp), forControlEvents: .TouchUpInside)
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
        
        userButton.setTitle("Already a member? Login", forState: .Normal)
        userButton.setTitleColor(Global.colorSelected, forState: .Normal)
        userButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        userButton.addTarget(self, action: #selector(signIn), forControlEvents: .TouchUpInside)
        userButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        userButton.sizeToFit()
        
        containerView.addSubview(facebookButton)
        containerView.addSubview(googleButton)
        containerView.addSubview(orLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(nameField)
        containerView.addSubview(emailField)
        containerView.addSubview(phoneField)
        containerView.addSubview(passwordField)
        containerView.addSubview(confirmField)
        containerView.addSubview(signUpButton)
        containerView.addSubview(userButton)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            facebookButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            facebookButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            facebookButton.autoSetDimension(.Height, toSize: 40)
            let facebookWidth = facebookButton.autoMatchDimension(.Width, toDimension: .Width, ofView: view, withMultiplier: 0.5)
            facebookWidth.constant = -15
            
            googleButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            googleButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            googleButton.autoSetDimension(.Height, toSize: 40)
            googleButton.autoPinEdge(.Left, toEdge: .Right, ofView: facebookButton, withOffset: 10)
            
            orLabel.autoPinEdgeToSuperviewEdge(.Left)
            orLabel.autoPinEdgeToSuperviewEdge(.Right)
            orLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: facebookButton, withOffset: 10)
            orLabel.autoSetDimension(.Height, toSize: 40)
            
            errorLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            errorLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            errorLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: orLabel, withOffset: 1)
            errorLabel.autoSetDimension(.Height, toSize: 20)
            
            nameField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            nameField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            nameField.autoPinEdge(.Top, toEdge: .Bottom, ofView: errorLabel, withOffset: 1)
            nameField.autoSetDimension(.Height, toSize: 40)
            
            nameBorder.autoPinEdgeToSuperviewEdge(.Left)
            nameBorder.autoPinEdgeToSuperviewEdge(.Right)
            nameBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            nameBorder.autoSetDimension(.Height, toSize: 1)
            
            emailField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            emailField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            emailField.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameField, withOffset: 10)
            emailField.autoSetDimension(.Height, toSize: 40)
            
            emailBorder.autoPinEdgeToSuperviewEdge(.Left)
            emailBorder.autoPinEdgeToSuperviewEdge(.Right)
            emailBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            emailBorder.autoSetDimension(.Height, toSize: 1)
            
            phoneField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            phoneField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            phoneField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailField, withOffset: 10)
            phoneField.autoSetDimension(.Height, toSize: 40)
            
            phoneBorder.autoPinEdgeToSuperviewEdge(.Left)
            phoneBorder.autoPinEdgeToSuperviewEdge(.Right)
            phoneBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            phoneBorder.autoSetDimension(.Height, toSize: 1)
            
            passwordField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            passwordField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            passwordField.autoPinEdge(.Top, toEdge: .Bottom, ofView: phoneField, withOffset: 10)
            passwordField.autoSetDimension(.Height, toSize: 40)
            
            passwordBorder.autoPinEdgeToSuperviewEdge(.Left)
            passwordBorder.autoPinEdgeToSuperviewEdge(.Right)
            passwordBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            passwordBorder.autoSetDimension(.Height, toSize: 1)
            
            confirmField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            confirmField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            confirmField.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordField, withOffset: 10)
            confirmField.autoSetDimension(.Height, toSize: 40)
            
            confirmBorder.autoPinEdgeToSuperviewEdge(.Left)
            confirmBorder.autoPinEdgeToSuperviewEdge(.Right)
            confirmBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            confirmBorder.autoSetDimension(.Height, toSize: 1)
            
            signUpButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            signUpButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            signUpButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: confirmField, withOffset: 20)
            signUpButton.autoSetDimension(.Height, toSize: 50)
            
            userButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: signUpButton, withOffset: 10)
            userButton.autoAlignAxisToSuperviewAxis(.Vertical)
            userButton.autoSetDimensionsToSize(userButton.frame.size)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 520
        containerView.frame = CGRectMake(0, 0, view.frame.width, height)
        scrollView.contentSize = containerView.bounds.size
    }
    
    
    func loginFacebook() {
        
    }
    
    func loginGoogle() {
        
    }
    
    func signIn() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func signUp() {
        if !checkInput(nameField, value: nameField.text) {
            return
        }
        if !checkInput(emailField, value: emailField.text) {
            return
        }
        if !checkInput(passwordField, value: passwordField.text) {
            return
        }
        if !checkInput(confirmField, value: confirmField.text) {
            return
        }
        if !checkInput(phoneField, value: phoneField.text) {
            return
        }
        
        view.endEditing(true)
        
        let name = nameField.text!
        let email = emailField.text!
        let phone = phoneField.text!
        let password = passwordField.text!
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        Global.client.GET("register_user",
                          parameters: [
                            "user_name": name,
                            "email": email,
                            "phone_number": phone,
                            "password": password] as NSDictionary,
                          progress:nil,
                          success: {
                            (task, response) in
                            if let response = response as? NSDictionary {
                                print(response)
                                let settings = NSUserDefaults()
                                settings.setObject(email, forKey: "email")
                                settings.setObject(password, forKey: "password")
                                settings.synchronize()
                                
                                SwiftOverlays.removeAllBlockingOverlays()
                                Global.user = User(response: response as? [String : String])
                                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
                                UIApplication.sharedApplication().keyWindow!.replaceRootViewControllerWith(DrawerViewController(), animated: true, completion: nil)
                            }
            }, failure: {
                (task, error) in
                SwiftOverlays.removeAllBlockingOverlays()
                self.errorLabel.text = "Invalid email or phone number"
        })
    }
    
    // delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).stringByReplacingCharactersInRange(range, withString: string)
        checkInput(textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            if checkInput(textField, value: textField.text) {
                textField.resignFirstResponder()
                emailField.becomeFirstResponder()
                return true
            }
        case emailField:
            if checkInput(textField, value: textField.text) {
                textField.resignFirstResponder()
                phoneField.becomeFirstResponder()
                return true
            }
        case phoneField:
            if checkInput(textField, value: textField.text) {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
                return true
            }
        case passwordField:
            if checkInput(textField, value: textField.text) {
                textField.resignFirstResponder()
                confirmField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField, value: textField.text) {
               textField.resignFirstResponder()
                signUp()
                return true
            }
        }
        
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case nameField:
            if value != nil && value!.isNotEmpty {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid name"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)

        case emailField:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid email address"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)
        
        case phoneField:
            if value != nil && value!.isValidPhone() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid phone number"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)
            
        case passwordField:
            if value != nil && value!.isNotEmpty {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid password"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)
        
        default:
            if value != nil && passwordField.text != nil && value! == passwordField.text! {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Password mismatch"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)
        }
        
        return false
    }
}
