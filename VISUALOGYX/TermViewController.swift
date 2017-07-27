//
//  TermViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class TermViewController: UIViewController {
    var constraintsAdded = false
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Terms And Conditions"
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        textView.editable = false
        
        let resourceURL = NSBundle.mainBundle().URLForResource("Terms", withExtension: "rtf")!
        try! textView.attributedText = NSAttributedString(fileURL: resourceURL, options: [:], documentAttributes: nil)
        view.addSubview(textView)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            textView.autoPinEdgesToSuperviewEdges()
        }
        super.updateViewConstraints()
    }
}
