//
//  ShareViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/4/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import FontAwesomeKit
import FBSDKCoreKit
import FBSDKShareKit
import SwiftOverlays
import Social

class ShareViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    let backgroundView = UIView()
    let anchorImage = UIImageView()
    let anchorUp = UIImageView()
    let anchorDown = UIImageView()
    let shareView = UIView()
    
    let facebookButton = UIButton()
    let twitterButton = UIButton()
    let whatsappButton = UIButton()

    
    var constraintsAdded = false

    var topConstraint : NSLayoutConstraint!
    var bottomConstraint : NSLayoutConstraint!

    var marginTopConstraint : NSLayoutConstraint!
    var marginLeftConstraint : NSLayoutConstraint!
    var heightConstraint : NSLayoutConstraint!
    var widthConstraint : NSLayoutConstraint!

    var anchorView : UIView!
    var inspection : Inspection!
    
    
    var documentInteractionController : UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareView.addSubview(facebookButton)
        shareView.addSubview(twitterButton)
        shareView.addSubview(whatsappButton)

        view.addSubview(backgroundView)
        view.addSubview(anchorImage)
        view.addSubview(anchorUp)
        view.addSubview(anchorDown)
        view.addSubview(shareView)
        
        backgroundView.backgroundColor = UIColor.blackColor().alpha(0.8)
        backgroundView.userInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
        let iconUp = FAKFontAwesome.caretUpIconWithSize(25)
        iconUp.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        anchorUp.image = iconUp.imageWithSize(CGSizeMake(25, 25))

        let iconDown = FAKFontAwesome.caretDownIconWithSize(25)
        iconDown.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        anchorDown.image = iconDown.imageWithSize(CGSizeMake(25, 25))
        
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.clipsToBounds = true
        shareView.layer.cornerRadius = 3

        facebookButton.setImage(UIImage(named: "facebook.png"), forState: .Normal)
        facebookButton.imageView?.contentMode = .ScaleAspectFit
        //facebookButton.addTarget(self, action: #selector(share), forControlEvents: .TouchUpInside)
        
        twitterButton.setImage(UIImage(named: "twitter.png"), forState: .Normal)
        twitterButton.imageView?.contentMode = .ScaleAspectFit
        //twitterButton.addTarget(self, action: #selector(share), forControlEvents: .TouchUpInside)
        
        whatsappButton.setImage(UIImage(named: "whatsapp.png"), forState: .Normal)
        whatsappButton.imageView?.contentMode = .ScaleAspectFit
        //whatsappButton.addTarget(self, action: #selector(share), forControlEvents: .TouchUpInside)
        
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
            
            bottomConstraint = shareView.autoPinEdge(.Top, toEdge: .Bottom, ofView: anchorImage, withOffset: 10)
            topConstraint = shareView.autoPinEdge(.Bottom, toEdge: .Top, ofView: anchorImage, withOffset: -10)

            shareView.autoSetDimension(.Height, toSize: 80)
            shareView.autoMatchDimension(.Width, toDimension: .Width, ofView: view, withOffset: -20)
            shareView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: anchorImage)
            
            anchorUp.autoSetDimensionsToSize(CGSizeMake(25, 25))
            anchorUp.autoPinEdge(.Bottom, toEdge: .Top, ofView: shareView, withOffset: 10)
            anchorUp.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: shareView, withOffset: -10)

            anchorDown.autoSetDimensionsToSize(CGSizeMake(25, 25))
            anchorDown.autoPinEdge(.Top, toEdge: .Bottom, ofView: shareView, withOffset: -10)
            anchorDown.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: shareView, withOffset: -10)
            
            facebookButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
            facebookButton.autoAlignAxisToSuperviewAxis(.Horizontal)
            facebookButton.autoAlignAxis(.Vertical, toSameAxisOfView: shareView, withOffset: -60)
            
            twitterButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
            twitterButton.autoAlignAxisToSuperviewAxis(.Horizontal)
            twitterButton.autoAlignAxis(.Vertical, toSameAxisOfView: shareView, withOffset: 0)
            
            whatsappButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
            whatsappButton.autoAlignAxisToSuperviewAxis(.Horizontal)
            whatsappButton.autoAlignAxis(.Vertical, toSameAxisOfView: shareView, withOffset: 60)
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
    
    // sharing
    
    var shareButton : UIButton?
    
    func share(sender: UIButton) {

        SwiftOverlays.showBlockingWaitOverlay()
        
        shareButton = sender
        
        if let image = inspection.image {
            if let url = NSURL(string: image) {
                AsyncImageLoader.sharedLoader().loadImageWithURL(url,
                                                                 target: self,
                                                                 success: #selector(imageLoaded),
                                                                 failure: #selector(imageFailedToLoad))
                return
            }
        }

        imageFailedToLoad()
    }
    
    func imageLoaded(image: UIImage, url: NSURL) {
        SwiftOverlays.removeAllBlockingOverlays()
        
        switch shareButton! {
        case facebookButton:
            let photo = FBSDKSharePhoto(image: image, userGenerated: true)
            let photoContent = FBSDKSharePhotoContent()
            photoContent.photos = [photo]
            FBSDKShareDialog.showFromViewController(self.parentViewController, withContent: photoContent, delegate: nil)
            
        case twitterButton:
            if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)) {
                let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                composeViewController.addImage(image)
                composeViewController.setInitialText(inspection.info)
                self.parentViewController?.presentViewController(composeViewController, animated: true, completion:nil)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: "Twitter service is not available!",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: {
                    _  in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        case whatsappButton:
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"whatsapp://app")!)) {
               let txtPath  = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/whatsAppTmp.wai")
                let fileManager = NSFileManager()
                
                if (fileManager.fileExistsAtPath(txtPath)) {
                    try! fileManager.removeItemAtPath(txtPath)
                }
                
                UIImageJPEGRepresentation(image, 1.0)!.writeToFile(txtPath, atomically: true)
                
                documentInteractionController = UIDocumentInteractionController(URL: NSURL.fileURLWithPath(txtPath))
                documentInteractionController.UTI = "net.whatsapp.image"
                documentInteractionController.name = inspection.type
                documentInteractionController.presentOpenInMenuFromRect(CGRectZero, inView:self.view, animated: true)
                
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: "Whatsapp is not installed!",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func imageFailedToLoad() {
        SwiftOverlays.removeAllBlockingOverlays()
        
        let alert = UIAlertController(title: "Error",
                                      message: "Failed to share. Please try again later!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startSharing(filename: String) {
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentTitle = inspection.type
        content.contentDescription = inspection.info
        content.imageURL = NSURL(string: filename)
    }
}
