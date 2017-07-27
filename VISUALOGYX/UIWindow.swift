//
//  SetRootViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/9/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

extension UIWindow {
    func replaceRootViewControllerWith(replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)
        self.rootViewController = replacementController
        self.bringSubviewToFront(snapshotImageView)
        if animated {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
            })
        }
        else {
            snapshotImageView.removeFromSuperview()
            completion?()
        }
    }
}