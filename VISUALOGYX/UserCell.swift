//
//  InspectionCell.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/4/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class UserCell : UITableViewCell {
    var constraintsAdded = false
    
    let avatarView = AsyncImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    
    var inspector : User! {
        didSet {
            avatarView.imageURL = nil
            if let thumb = inspector.thumb {
                if let url = NSURL(string: thumb, relativeToURL: NSURL(string: Global.baseURL)!) {
                    avatarView.imageURL = url
                }
            }
            nameLabel.text = inspector.username
            emailLabel.text = inspector.email
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    func commonInit() {
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        
        self.backgroundColor = UIColor.clearColor()
        
        avatarView.contentMode = .ScaleAspectFill
        avatarView.layer.cornerRadius = 5
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarView.backgroundColor = Global.colorSelected
        
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 1
        
        emailLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.numberOfLines = 1
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            avatarView.autoPinEdgeToSuperviewEdge(.Left, withInset: 5)
            avatarView.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
            avatarView.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withOffset: -10)
            avatarView.autoMatchDimension(.Width, toDimension: .Height, ofView: avatarView)

            nameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 5)
            nameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 5)
            nameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
            nameLabel.autoSetDimension(.Height, toSize: 25)

            emailLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatarView, withOffset: 5)
            emailLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 5)
            emailLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
            emailLabel.autoSetDimension(.Height, toSize: 20)
        }
        super.updateConstraints()
    }
}
