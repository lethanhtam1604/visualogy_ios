//
//  MenuView.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/2/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import FontAwesomeKit

enum MenuItem {
    case None
    case Home
    case Inspections
    case Training
    case History
    case About
    case Logout
}

protocol MenuViewDelegate {
    func menuWillHide()
    func menuDidHide()
    func menuWillShow()
    func menuDidShow()
    func menuItemDidChange()
}

class MenuView: UIView {
    private var constraintsAdded = false

    private var menuLeftConstraint : NSLayoutConstraint!

    private let scrollView = UIScrollView()
    private let backgroundView = UIView()
    
    private let headerView = GradientView()
    private let avatarView = UIImageView(frame: CGRectZero)
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    
    private let homeButton = UIButton()
    private let inspectionButton = UIButton()
    private let trainingButton = UIButton()
    private let historyButton = UIButton()
    private let aboutButton = UIButton()
    private let logoutButton = UIButton()
    
    private var menuButtons : [UIButton]!
    private let menuWidth : CGFloat = 250
    
    private var selectedButton : UIButton! {
        didSet {
            for menuButton in menuButtons {
                if menuButton != selectedButton {
                    menuButton.backgroundColor = UIColor.clearColor()
                    menuButton.selected = false
                } else {
                    menuButton.backgroundColor = Global.colorSelected
                    menuButton.selected = true
                }
            }
            
            switch selectedButton {
            case homeButton:
                _selectedItem = .Home
            case trainingButton:
                _selectedItem = .Training
            case inspectionButton:
                _selectedItem = .Inspections
            case historyButton:
                _selectedItem = .History
            case aboutButton:
                _selectedItem = .About
            case logoutButton:
                _selectedItem = .Logout
            default:
                _selectedItem = .None
            }
            
        }
    }
    
    private var _selectedItem : MenuItem!
    
    var selectedItem : MenuItem {
        get {
            return _selectedItem
        }
        
        set(newValue) {
            switch newValue {
            case .Home:
                selectedButton = homeButton
            case .Inspections:
                selectedButton = inspectionButton
            case .Training:
                selectedButton = trainingButton
            case .History:
                selectedButton = historyButton
            case .About:
                selectedButton = aboutButton
            case .Logout:
                selectedButton = logoutButton
            default:
                break
            }
            delegate?.menuItemDidChange()
        }
    }
    
    var delegate : MenuViewDelegate?
    
    // UI
    
    init() {
        super.init(frame: CGRectZero)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        headerView.addSubview(avatarView)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(emailLabel)
        
        scrollView.addSubview(headerView)
        
        addSubview(backgroundView)
        addSubview(scrollView)
        
        menuButtons = [homeButton, inspectionButton, trainingButton, historyButton, aboutButton, logoutButton]
        
        for menuButton in menuButtons {
            scrollView.addSubview(menuButton)

            menuButton.setTitleColor(Global.colorSelected, forState: .Normal)
            menuButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            menuButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            menuButton.titleLabel?.textAlignment = .Left
            menuButton.imageView?.contentMode = .ScaleAspectFit
            menuButton.contentEdgeInsets = UIEdgeInsetsZero
            
            menuButton.addTarget(self, action: #selector(highlightMenuItem), forControlEvents: .TouchDown)
            menuButton.addTarget(self, action: #selector(selectMenuItem), forControlEvents: .TouchUpInside)
            menuButton.addTarget(self, action: #selector(unhighlightMenuItem), forControlEvents: .TouchCancel)
            menuButton.addTarget(self, action: #selector(unhighlightMenuItem), forControlEvents: .TouchUpOutside)
            menuButton.addTarget(self, action: #selector(unhighlightMenuItem), forControlEvents: .TouchDragOutside)
        }
        
        self.hidden = true
        self.backgroundColor = UIColor.clearColor()
        
        backgroundView.backgroundColor = UIColor.clearColor()
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuView.hide)))
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.indicatorStyle = .Default
        
        avatarView.contentMode = .ScaleAspectFill
        avatarView.layer.cornerRadius = 5
        avatarView.clipsToBounds = true
        avatarView.image = UIImage(named: "default.png")
        
        emailLabel.textColor = UIColor.whiteColor()
        emailLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        emailLabel.textAlignment = .Left
        emailLabel.numberOfLines = 1
        emailLabel.adjustsFontSizeToFitWidth = true

        usernameLabel.textColor = UIColor.whiteColor()
        usernameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        usernameLabel.textAlignment = .Left
        usernameLabel.numberOfLines = 1
        usernameLabel.adjustsFontSizeToFitWidth = true

        
        homeButton.setImage(UIImage(named: "home.png"), forState: .Normal)
        homeButton.setImage(UIImage(named: "home_1.png"), forState: .Highlighted)
        homeButton.setImage(UIImage(named: "home_1.png"), forState: .Selected)
        homeButton.setTitle("Home", forState: .Normal)
        
        inspectionButton.setImage(UIImage(named: "inspections.png"), forState: .Normal)
        inspectionButton.setImage(UIImage(named: "inspections_1.png"), forState: .Highlighted)
        inspectionButton.setImage(UIImage(named: "inspections_1.png"), forState: .Selected)
        inspectionButton.setTitle("Inspections", forState: .Normal)

        let trainingIcon = FAKFontAwesome.mortarBoardIconWithSize(35)
        trainingIcon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSelected)
        trainingButton.setImage(trainingIcon.imageWithSize(CGSizeMake(35, 35)), forState: .Normal)
        trainingIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        trainingButton.setImage(trainingIcon.imageWithSize(CGSizeMake(35, 35)), forState: .Highlighted)
        trainingButton.setImage(trainingIcon.imageWithSize(CGSizeMake(35, 35)), forState: .Selected)
        trainingButton.setTitle("Training", forState: .Normal)

        historyButton.setImage(UIImage(named: "history.png"), forState: .Normal)
        historyButton.setImage(UIImage(named: "history_1.png"), forState: .Highlighted)
        historyButton.setImage(UIImage(named: "history_1.png"), forState: .Selected)
        historyButton.setTitle("History", forState: .Normal)
        
        aboutButton.setImage(UIImage(named: "about.png"), forState: .Normal)
        aboutButton.setImage(UIImage(named: "about_1.png"), forState: .Highlighted)
        aboutButton.setImage(UIImage(named: "about_1.png"), forState: .Selected)
        aboutButton.setTitle("About", forState: .Normal)

        let logoutIcon = FAKFontAwesome.powerOffIconWithSize(35)
        logoutIcon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSelected)
        logoutButton.setImage(logoutIcon.imageWithSize(CGSizeMake(35, 35)), forState: .Normal)
        logoutIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        logoutButton.setImage(logoutIcon.imageWithSize(CGSizeMake(35, 35)), forState: .Highlighted)
        logoutButton.setImage(logoutIcon.imageWithSize(CGSizeMake(35, 35)), forState: .Selected)
        logoutButton.setTitle("Logout", forState: .Normal)

        
        selectedButton = homeButton
        
        let user = Global.user
        emailLabel.text = user.email
        usernameLabel.text = user.username
        
        if let thumbStr = user.thumb {
            if let thumb = NSURL(string: thumbStr) {
                avatarView.imageURL = thumb
            }
        }
        
        if user.userType != "manager" {
            inspectionButton.removeFromSuperview()
        }
        
        setNeedsLayout()
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            backgroundView.autoPinEdgesToSuperviewEdges()
            
            menuLeftConstraint = scrollView.autoPinEdgeToSuperviewEdge(.Left, withInset: -menuWidth)
            scrollView.autoPinEdgeToSuperviewEdge(.Top)
            scrollView.autoMatchDimension(.Height, toDimension: .Height, ofView: self)
            scrollView.autoSetDimension(.Width, toSize: menuWidth)
            
            headerView.autoPinEdgeToSuperviewEdge(.Left)
            headerView.autoPinEdgeToSuperviewEdge(.Top)
            headerView.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView)
            headerView.autoSetDimension(.Height, toSize: 120)
            
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            avatarView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
            avatarView.autoSetDimensionsToSize(CGSizeMake(70, 70))

            emailLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 90)
            emailLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
            emailLabel.autoPinEdgeToSuperviewEdge(.Right)
            emailLabel.autoSetDimension(.Height, toSize: 20)
            
            usernameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 90)
            usernameLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 35)
            usernameLabel.autoPinEdgeToSuperviewEdge(.Right)
            usernameLabel.autoSetDimension(.Height, toSize: 20)
            
            for menuButton in menuButtons {
                if menuButton.superview == nil {
                    continue
                }
                
                menuButton.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView)
                menuButton.autoSetDimension(.Height, toSize: 65)
                menuButton.autoPinEdgeToSuperviewEdge(.Left)
                
                menuButton.imageView?.autoSetDimensionsToSize(CGSizeMake(35, 35))
                menuButton.imageView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
                menuButton.imageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 15)
                
                menuButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Top)
                menuButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Bottom)
                menuButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Right)
                menuButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 60)
            }
 
            homeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerView)
            if inspectionButton.superview != nil {
                inspectionButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: homeButton)
                trainingButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: inspectionButton)
            } else {
                trainingButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: homeButton)
            }
            historyButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: trainingButton)
            aboutButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: historyButton)
            logoutButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: aboutButton)
        }
        
        super.updateConstraints()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.autoPinEdgesToSuperviewEdges()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSizeMake(headerView.bounds.width, 120 + 65 * 5 + 10)
    }
    
    // events
    
    func highlightMenuItem(item: UIButton) {
        item.backgroundColor = Global.colorSelected
    }
    
    func unhighlightMenuItem(item: UIButton) {
        if !item.selected {
            item.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func selectMenuItem(item: UIButton) {
        item.backgroundColor = UIColor.whiteColor()
        selectedButton = item;
        delegate?.menuItemDidChange()
    }
    
    // actions
    
    func show() {
        delegate?.menuWillShow()
        
        self.hidden = false
        menuLeftConstraint.constant = 0
        UIView.animateWithDuration(0.3, animations: {
            self.layoutIfNeeded()
            self.backgroundView.backgroundColor = UIColor.blackColor().alpha(0.9)
            }, completion: {
                _ in
                self.delegate?.menuDidShow()
        })
    }
    
    func hide() {
        if self.hidden {
            return
        }
        
        delegate?.menuWillHide()
        menuLeftConstraint.constant = -menuWidth
        UIView.animateWithDuration(0.3, animations: {
            self.layoutIfNeeded()
            self.backgroundView.backgroundColor = UIColor.clearColor()
            }, completion: {
                _ in
                self.delegate?.menuDidHide()
                self.hidden = true
        })
    }
}
