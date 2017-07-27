//
//  InspectionSeparator.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/4/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class InspectionSeparator : UITableViewCell {
    var constraintsAdded = false
    
    let separatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        addSubview(separatorView)
        
        separatorView.backgroundColor = Global.colorSecond
        selectionStyle = .None
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            separatorView.autoPinEdgeToSuperviewEdge(.Top)
            separatorView.autoPinEdgeToSuperviewEdge(.Bottom)
            separatorView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            separatorView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        }
        super.updateConstraints()
    }
}