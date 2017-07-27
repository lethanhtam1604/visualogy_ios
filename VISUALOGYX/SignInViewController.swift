//
//  SigninViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/8/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import PasswordTextField
import SwiftOverlays
import SimpleAuth
import M13Checkbox

class SignInViewController: UIViewController, UITextFieldDelegate {
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let facebookButton = UIButton()
    let googleButton = UIButton()
    let orLabel = UILabel()
    let errorLabel = UILabel()
    let emailField = UITextField()
    let emailBorder = UIView()
    let passwordField = PasswordTextField()
    let passwordBorder = UIView()
    let forgotButton = UIButton()
    let signInButton = UIButton()
    let newUserButton = UIButton()
    let rememberBox = M13Checkbox(frame: CGRectZero)
    let rememberButton = UIButton()
    let splashView = UIImageView(image: UIImage(named: "splash.png"))
    
    var constraintsAdded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = NSUserDefaults.standardUserDefaults()
        let email = settings.stringForKey("email")
        let password = settings.stringForKey("password")
        if email != nil {
            navigationController?.navigationBarHidden = true
            splashView.hidden = false
            splashView.contentMode = .ScaleAspectFill
            startSigningIn(email!, password: password!)
        } else {
            splashView.hidden = true
        }
        
        self.title = "Sign In"
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
        
        emailField.placeholder = "Email or phone number"
        emailField.delegate = self
        emailField.textColor = Global.colorSecond
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .Next
        emailField.keyboardType = .EmailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .No
        emailField.autocapitalizationType = .None
        
        emailBorder.backgroundColor = Global.colorBg
        
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.textColor = Global.colorSecond
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .Go
        passwordField.keyboardType = .ASCIICapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .No
        passwordField.autocapitalizationType = .None
        passwordBorder.backgroundColor = Global.colorBg
        
        
        forgotButton.setTitle("Forgot Password?", forState: .Normal)
        forgotButton.setTitleColor(Global.colorSelected, forState: .Normal)
        forgotButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        forgotButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        forgotButton.addTarget(self, action: #selector(forgot), forControlEvents: .TouchUpInside)
        forgotButton.sizeToFit()
        
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        signInButton.insertSubview(GradientView(autoFit: true), atIndex: 0)
        signInButton.addTarget(self, action: #selector(signIn), forControlEvents: .TouchUpInside)
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        
        newUserButton.setTitle("New User?", forState: .Normal)
        newUserButton.setTitleColor(Global.colorSelected, forState: .Normal)
        newUserButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        newUserButton.addTarget(self, action: #selector(signUp), forControlEvents: .TouchUpInside)
        newUserButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        newUserButton.sizeToFit()
        
        rememberBox.boxType = .Square
        rememberBox.markType = .Checkmark
        rememberBox.stateChangeAnimation = .Bounce(.Stroke)
        
        rememberButton.setTitle("Remember Me?", forState: .Normal)
        rememberButton.setTitleColor(Global.colorSelected, forState: .Normal)
        rememberButton.setTitleColor(Global.colorSecond, forState: .Highlighted)
        rememberButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        rememberButton.addTarget(self, action: #selector(remember), forControlEvents: .TouchUpInside)
        rememberButton.sizeToFit()
        
        containerView.addSubview(facebookButton)
        containerView.addSubview(googleButton)
        containerView.addSubview(orLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(forgotButton)
        containerView.addSubview(signInButton)
        containerView.addSubview(newUserButton)
        containerView.addSubview(rememberBox)
        containerView.addSubview(rememberButton)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(splashView)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            splashView.autoPinEdgesToSuperviewEdges()
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
            orLabel.autoSetDimension(.Height, toSize: 30)
            
            errorLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            errorLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            errorLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: orLabel, withOffset: 1)
            errorLabel.autoSetDimension(.Height, toSize: 20)
            
            emailField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            emailField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            emailField.autoPinEdge(.Top, toEdge: .Bottom, ofView: errorLabel, withOffset: 1)
            emailField.autoSetDimension(.Height, toSize: 40)
            
            emailBorder.autoPinEdgeToSuperviewEdge(.Left)
            emailBorder.autoPinEdgeToSuperviewEdge(.Right)
            emailBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            emailBorder.autoSetDimension(.Height, toSize: 1)
            
            passwordField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            passwordField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            passwordField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailField, withOffset: 10)
            passwordField.autoSetDimension(.Height, toSize: 40)
            
            passwordBorder.autoPinEdgeToSuperviewEdge(.Left)
            passwordBorder.autoPinEdgeToSuperviewEdge(.Right)
            passwordBorder.autoPinEdgeToSuperviewEdge(.Bottom)
            passwordBorder.autoSetDimension(.Height, toSize: 1)
            
            forgotButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
            forgotButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordField)
            forgotButton.autoSetDimensionsToSize(forgotButton.frame.size)
            
            rememberBox.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            rememberBox.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordField, withOffset: 5)
            rememberBox.autoSetDimensionsToSize(CGSizeMake(15, 15))

            rememberButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 28)
            rememberButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordField)
            rememberButton.autoSetDimensionsToSize(rememberButton.frame.size)
            
            signInButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            signInButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            signInButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: forgotButton, withOffset: 20)
            signInButton.autoSetDimension(.Height, toSize: 50)
            
            newUserButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: signInButton, withOffset: 10)
            newUserButton.autoAlignAxisToSuperviewAxis(.Vertical)
            newUserButton.autoSetDimensionsToSize(newUserButton.frame.size)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 420
        containerView.frame = CGRectMake(0, 0, view.frame.width, height)
        scrollView.contentSize = containerView.bounds.size
    }
    
    
    func loginFacebook() {
    }
    
    func loginGoogle() {
    }
    
    func forgot() {
        let forgotController = PasswordViewController()
        if let email = self.emailField.text {
            if email.isValidEmail() {
                forgotController.email = email
            }
        }
        self.navigationController?.pushViewController(forgotController, animated: true)
    }
    
    func signIn() {
//        if !checkInput(emailField, value: emailField.text) || !checkInput(passwordField, value: passwordField.text) {
//            return
//        }
//        
//        view.endEditing(true)
//        
//        let email = emailField.text!
//        let password = passwordField.text!
//        
//        SwiftOverlays.showBlockingWaitOverlay()
        startSigningIn("", password: "")
    }
    
    func startSigningIn(email: String, password: String) {
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        UIApplication.sharedApplication().keyWindow!.replaceRootViewControllerWith(DrawerViewController(), animated: true, completion: nil)
        self.splashView.hidden = true
        
//        var params : [String : String]!
//        if email.isValidEmail() {
//            params = [
//                "email": email,
//                "password": password]
//        } else {
//            params = [
//                "phone_number": email,
//                "password": password]
//        }
//        
//        Global.client.GET("login",
//                          parameters: params as NSDictionary,
//                          progress:nil,
//                          success: {
//                            (task, response) in
//                            if let response = response as? NSDictionary {
//                                if let error = response.objectForKey("error_description") as? String {
//                                    SwiftOverlays.removeAllBlockingOverlays()
//                                    self.errorLabel.text = error
//                                    self.splashView.hidden = true
//                                    self.navigationController?.navigationBarHidden = false
//                                } else {
//                                    if(self.rememberBox.checkState == .Checked) {
//                                        let settings = NSUserDefaults()
//                                        settings.setObject(email, forKey: "email")
//                                        settings.setObject(password, forKey: "password")
//                                        settings.synchronize()
//                                    }
//                                    
//                                    SwiftOverlays.removeAllBlockingOverlays()
//                                    Global.user = User(response: response as? [String : String])
//                                    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
//                                    UIApplication.sharedApplication().keyWindow!.replaceRootViewControllerWith(DrawerViewController(), animated: true, completion: nil)
//                                    self.splashView.hidden = true
//                                }
//                            }
//            }, failure: {
//                (task, error) in
//                print(error)
//                SwiftOverlays.removeAllBlockingOverlays()
//                self.errorLabel.text = error.localizedDescription
//                self.splashView.hidden = true
//                self.navigationController?.navigationBarHidden = false
//        })
    }
    
    func signUp() {
        let signUpController = SignUpViewController()
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    func remember() {
        rememberBox.toggleCheckState(true)
    }
    
    // delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).stringByReplacingCharactersInRange(range, withString: string)
        checkInput(textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            if checkInput(textField, value: textField.text) {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
                return true
            }
            return false
        } else {
            if checkInput(textField, value: textField.text) {
                textField.resignFirstResponder()
                signIn()
                return true
            }
            return false
        }
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        if textField == emailField {
            if value != nil && (value!.isValidEmail() || value!.isValidPhone()) {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            
            errorLabel.text = "Invalid email/phone number"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)
            return false
            
        } else {
            if value != nil && value!.isNotEmpty {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            
            errorLabel.text = "Invalid password"
            textField.subviews.first?.backgroundColor = UIColor.redColor().alpha(0.8)
            return false
        }
    }
}
