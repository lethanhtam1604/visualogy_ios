//
//  AboutViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AboutViewController: UIViewController {
    var constraintsAdded = false
    
    let logoView = UIImageView(image: UIImage(named: "logo_orange.png"))
    let versionLabel = UILabel()
    let descriptionLabel = UILabel()
    let termButton = UIButton()
    let licenseButton = UIButton()
    let seperatorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        
        self.title = "About"
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let menuIcon = FAKIonIcons.androidMenuIconWithSize(30)
        menuIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let menuImg  = menuIcon.imageWithSize(CGSizeMake(30, 30))
        let menuButton = UIBarButtonItem(image: menuImg, style: .Plain, target: self, action: #selector(showMenu))
        self.navigationItem.leftBarButtonItem = menuButton

        logoView.contentMode = .ScaleAspectFit
        
        versionLabel.text = "v1.0.0"
        versionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        versionLabel.adjustsFontSizeToFitWidth = true
        versionLabel.textAlignment = .Center
        versionLabel.textColor = Global.colorSelected
        
        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.textColor = Global.colorSelected
        
        seperatorView.backgroundColor = UIColor.lightGrayColor().alpha(0.2)
        
        let arrowIcon = FAKFontAwesome.angleRightIconWithSize(30)
        arrowIcon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSelected)
        let arrowImg  = arrowIcon.imageWithSize(CGSizeMake(30, 30))

        termButton.setTitle("Terms And Conditions", forState: .Normal)
        termButton.setImage(arrowImg, forState: .Normal)
        termButton.setTitleColor(Global.colorSelected, forState: .Normal)
        termButton.addTarget(self, action: #selector(showTerms), forControlEvents: .TouchUpInside)
        termButton.titleLabel?.textAlignment = .Left
        termButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        termButton.titleLabel?.adjustsFontSizeToFitWidth = true
        termButton.imageView?.contentMode = .Right
        
        licenseButton.setTitle("License", forState: .Normal)
        licenseButton.setImage(arrowImg, forState: .Normal)
        licenseButton.setTitleColor(Global.colorSelected, forState: .Normal)
        licenseButton.addTarget(self, action: #selector(showLicense), forControlEvents: .TouchUpInside)
        licenseButton.titleLabel?.textAlignment = .Left
        licenseButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        licenseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        licenseButton.imageView?.contentMode = .Right
        
        
        view.addSubview(logoView)
        view.addSubview(versionLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(termButton)
        view.addSubview(seperatorView)
        view.addSubview(licenseButton)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let margin : CGFloat = 20
            
            licenseButton.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            licenseButton.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            licenseButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
            licenseButton.autoSetDimension(.Height, toSize: 60)
            licenseButton.autoMatchDimension(.Width, toDimension: .Width, ofView: view, withOffset: -2 * margin)

            licenseButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Top)
            licenseButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Bottom)
            licenseButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Left)
            licenseButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 60)
            
            licenseButton.imageView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
            licenseButton.imageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 15)
            licenseButton.imageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
            licenseButton.imageView?.autoSetDimension(.Width, toSize: 30)
            licenseButton.imageView?.autoSetDimension(.Height, toSize: 30)
            
            seperatorView.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            seperatorView.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            seperatorView.autoPinEdge(.Bottom, toEdge: .Top, ofView: licenseButton)
            seperatorView.autoSetDimension(.Height, toSize: 1)
            seperatorView.autoMatchDimension(.Width, toDimension: .Width, ofView: view, withOffset: -2 * margin)
            
            termButton.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            termButton.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            termButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: seperatorView)
            termButton.autoSetDimension(.Height, toSize: 60)
            termButton.autoMatchDimension(.Width, toDimension: .Width, ofView: view, withOffset: -2 * margin)
            
            termButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Top)
            termButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Bottom)
            termButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Left)
            termButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 60)
            
            termButton.imageView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
            termButton.imageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 15)
            termButton.imageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
            termButton.imageView?.autoSetDimension(.Width, toSize: 30)
            termButton.imageView?.autoSetDimension(.Height, toSize: 30)
            
            logoView.autoPinEdgeToSuperviewEdge(.Left)
            logoView.autoPinEdgeToSuperviewEdge(.Right)
            logoView.autoPinEdgeToSuperviewEdge(.Top)
            logoView.autoSetDimension(.Height, toSize: 80)
            logoView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)
            
            versionLabel.autoPinEdgeToSuperviewEdge(.Left)
            versionLabel.autoPinEdgeToSuperviewEdge(.Right)
            versionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoView)
            versionLabel.autoSetDimension(.Height, toSize: 30)
            versionLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

            descriptionLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: margin)
            descriptionLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: margin)
            descriptionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: versionLabel)
            descriptionLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: termButton)
        }
        super.updateViewConstraints()
    }
    
    func showMenu() {
        if let drawer = self.navigationController?.parentViewController as? DrawerViewController {
            drawer.showMenu()
        }
    }
    
    func showTerms() {
        self.navigationController?.pushViewController(TermViewController(), animated: true)
    }
    
    func showLicense() {
        self.navigationController?.pushViewController(LicenseViewController(), animated: true)
    }
}
