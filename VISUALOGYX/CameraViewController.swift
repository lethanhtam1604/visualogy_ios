//
//  InspectionViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 9/23/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import MobileCoreServices
import PureLayout
import FontAwesomeKit
import AVFoundation
import QuartzCore

protocol CameraControllerDelegate {
    func cameraDidCaptureVideo(info: [String : AnyObject])
    func showMenu()
}

class CameraViewController: UIImagePickerController, CaptureButtonDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var constraintsAdded = false

    var hintLeftConstraint : NSLayoutConstraint!
    var hintRightConstraint : NSLayoutConstraint!
    
    var torchOn = false
    var capturing = false
    
    let overlayView = UIView()
    let hintLabel = UILabel()
    let squareView = SquareView()
    let captureButton = CaptureButton()
    let switchButton = UIButton()
    let galleryButton = UIButton()
    let menuButton = UIButton()
    let flashButton = UIButton()
    
    var cameraDelegate : CameraControllerDelegate?
    
    // setup UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup overlay
        
        captureButton.delegate = self
        
        menuButton.setImage(UIImage(named: "menu.png"), forState: .Normal)
        menuButton.addTarget(self, action: #selector(showMenu), forControlEvents: .TouchUpInside)
        menuButton.imageView?.contentMode = .ScaleAspectFit
        
        let flashIcon = FAKIonIcons.flashIconWithSize(30)
        flashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let flashImg  = flashIcon.imageWithSize(CGSizeMake(40, 40))
        flashButton.setImage(flashImg, forState: .Normal)
        flashButton.addTarget(self, action: #selector(toggleFlash), forControlEvents: .TouchUpInside)
        flashButton.imageView?.contentMode = .ScaleAspectFit
        
        switchButton.setImage(UIImage(named: "switch-camera.png"), forState: .Normal)
        switchButton.addTarget(self, action: #selector(switchCamera), forControlEvents: .TouchUpInside)
        switchButton.imageView?.contentMode = .ScaleAspectFit
        
        galleryButton.setImage(UIImage(named: "gallery.png"), forState: .Normal)
        galleryButton.addTarget(self, action: #selector(showGallery), forControlEvents: .TouchUpInside)
        galleryButton.imageView?.contentMode = .ScaleAspectFit
        
        hintLabel.text = "Position the pipe on the square"
        hintLabel.adjustsFontSizeToFitWidth = true
        hintLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        hintLabel.textColor = UIColor.whiteColor()
        hintLabel.alpha = 0.8
        hintLabel.textAlignment = .Center
        
        overlayView.addSubview(hintLabel)
        overlayView.addSubview(squareView)
        overlayView.addSubview(captureButton)
        overlayView.addSubview(switchButton)
        overlayView.addSubview(galleryButton)
        overlayView.addSubview(menuButton)
        overlayView.addSubview(flashButton)
        
        view.addSubview(overlayView)


        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            overlayView.autoPinEdgesToSuperviewEdges()
            squareView.autoPinEdgesToSuperviewEdges()

            hintLeftConstraint = hintLabel.autoPinEdgeToSuperviewMargin(.Left)
            hintRightConstraint = hintLabel.autoPinEdgeToSuperviewMargin(.Right)
            hintLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 90)
            
            captureButton.autoAlignAxisToSuperviewAxis(.Vertical)
            captureButton.autoPinEdgeToSuperviewMargin(.Bottom)
            captureButton.autoSetDimension(.Width, toSize: 80)
            captureButton.autoSetDimension(.Height, toSize: 80)
            
            menuButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            menuButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            menuButton.autoSetDimension(.Width, toSize: 40)
            menuButton.autoSetDimension(.Height, toSize: 40)
            
            flashButton.autoPinEdgeToSuperviewMargin(.Right)
            flashButton.autoPinEdgeToSuperviewMargin(.Top)
            flashButton.autoSetDimension(.Width, toSize: 40)
            flashButton.autoSetDimension(.Height, toSize: 40)
            
            switchButton.autoPinEdgeToSuperviewMargin(.Left)
            switchButton.autoPinEdgeToSuperviewMargin(.Bottom)
            switchButton.autoSetDimension(.Width, toSize: 40)
            switchButton.autoSetDimension(.Height, toSize: 30)
            
            galleryButton.autoPinEdgeToSuperviewMargin(.Right)
            galleryButton.autoPinEdgeToSuperviewMargin(.Bottom)
            galleryButton.autoSetDimension(.Width, toSize: 40)
            galleryButton.autoSetDimension(.Height, toSize: 30)
        }
        super.updateViewConstraints()
        
        
        var angle : Double!
        var offset = CGSizeZero
        
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            angle = 0
            offset = CGSizeMake(2, 2)
            hintLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hintLeftConstraint.constant = 0
            hintLeftConstraint.active = true
            hintRightConstraint.constant = 0
            hintRightConstraint.active = true
            
            
        case .PortraitUpsideDown:
            angle = M_PI
            offset = CGSizeMake(-2, -2)
            hintLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hintLeftConstraint.constant = 0
            hintLeftConstraint.active = true
            hintRightConstraint.constant = 0
            hintRightConstraint.active = true
            
        case .LandscapeLeft:
            angle = M_PI_2
            offset = CGSizeMake(-2, 2)
            hintLabel.layer.anchorPoint = CGPointMake(0, 0)
            hintLeftConstraint.constant = -80
            hintLeftConstraint.active = true
            hintRightConstraint.constant = 0
            hintRightConstraint.active = false
            
        case .LandscapeRight:
            angle = -M_PI_2
            offset = CGSizeMake(2, -2)
            hintLabel.layer.anchorPoint = CGPointMake(1, 1)
            hintLeftConstraint.constant = 0
            hintLeftConstraint.active = false
            hintRightConstraint.constant = 100
            hintRightConstraint.active = true
            
        default:
            angle = Double.infinity
        }
        
        if angle != Double.infinity {
            UIView.animateWithDuration(0.25, animations:{
                let transform = CGAffineTransformMakeRotation(CGFloat(angle))
                
                self.switchButton.transform = transform
                self.galleryButton.transform = transform
                self.menuButton.transform = transform
                self.flashButton.transform = transform
                self.hintLabel.transform = transform
                self.captureButton.shadowOffset = offset
                self.view.layoutIfNeeded()
                }, completion: {
                    _ in
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(orientationChanged),
                                                         name: UIDeviceOrientationDidChangeNotification,
                                                         object: nil)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)

        showPicker(0)
        squareView.moveSquareToCenter()
        
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) !=  AVAuthorizationStatus.Authorized
        {
            overlayView.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIDeviceOrientationDidChangeNotification,
                                                            object: nil)
    }
    
    func orientationChanged() {
        view.setNeedsUpdateConstraints()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // permissions
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let settings = NSUserDefaults.standardUserDefaults()
        let shouldShowHint = !settings.boolForKey("hintCamera")
        settings.setBool(true, forKey: "hintCamera")
        settings.synchronize()
        
        if !shouldShowHint {
            hintLabel.hidden = true
            return
        }
        
        hintLabel.alpha = 0
        hintLabel.hidden = false
        UIView.animateWithDuration(0.2, animations: {
            self.hintLabel.alpha = 1
            }, completion: {
                _ in
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue(), {
                    UIView.animateWithDuration(0.2, animations: {
                        self.hintLabel.alpha = 0
                        }, completion: {
                            _ in
                            self.hintLabel.hidden = true
                    })
                })
                
        })

    }
    
    // control events
    
    func showPicker(state: Int) {
        if state == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                self.allowsEditing = false
                self.sourceType = .Camera
                self.showsCameraControls = false

                if #available(iOS 10.0, *) {
                    self.mediaTypes = [kUTTypeMovie as String]
                } else {
                    let screenSize = UIScreen.mainScreen().bounds.size
                    let scale = screenSize.height / (screenSize.width / 3 * 4)
                    let translateY = (screenSize.height - (screenSize.width / 3 * 4)) / 2
                    
                    self.cameraViewTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, translateY)
                    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, scale, scale)
                    
                    self.mediaTypes = [kUTTypeImage as String]
                }
                
                self.delegate = self
                self.cameraFlashMode = .Off
                
                let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
                if device .hasTorch && device.hasFlash {
                    try! device.lockForConfiguration()
                    device.torchMode = .Off
                    device.flashMode = .Off
                    device.unlockForConfiguration()
                }
            } else {
                self.overlayView.backgroundColor = UIColor.blackColor()
                self.captureButton.enabled = false
            }
            
            self.overlayView.hidden = false
            self.menuButton.hidden = false
            self.flashButton.hidden = false
            self.switchButton.hidden = false
            self.galleryButton.hidden = false
            self.captureButton.hidden = false
            
            self.torchOn = false
            let flashIcon = FAKIonIcons.flashIconWithSize(30)
            flashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            let flashImg  = flashIcon.imageWithSize(CGSizeMake(40, 40))
            flashButton.setImage(flashImg, forState: .Normal)

        } else if state == 1 {
            self.sourceType = .PhotoLibrary
            self.mediaTypes = [kUTTypeImage as String]
            self.delegate = self
            
            self.overlayView.hidden = true
            self.menuButton.hidden = true
            self.flashButton.hidden = true
            self.switchButton.hidden = true
            self.galleryButton.hidden = true
            self.captureButton.hidden = true
        }
        
        self.view.setNeedsUpdateConstraints()
    }
    
    func toggleFlash() {
        var flashIcon : FAKIcon!
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device .hasTorch && device.hasFlash {
            try! device.lockForConfiguration()
            if !device.torchActive {
                device.torchMode = .On
                device.flashMode = .On
                torchOn = true
                flashIcon = FAKIonIcons.flashOffIconWithSize(40)
            } else {
                device.torchMode = .Off
                device.flashMode = .Off
                torchOn = false
                flashIcon = FAKIonIcons.flashIconWithSize(40)
            }
            device.unlockForConfiguration()
        }
        
        flashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let flashImg  = flashIcon.imageWithSize(CGSizeMake(40, 40))
        flashButton.setImage(flashImg, forState: .Normal)
    }
    
    func showMenu() {
        cameraDelegate?.showMenu()
    }
    
    func showGallery() {
        showPicker(1)
    }
    
    func switchCamera() {
        if(self.cameraDevice == .Front) {
            self.cameraDevice = .Rear;
            
            torchOn = false
            let flashIcon = FAKIonIcons.flashIconWithSize(40)
            flashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            let flashImg  = flashIcon.imageWithSize(CGSizeMake(40, 40))
            flashButton.setImage(flashImg, forState: .Normal)
            flashButton.hidden = false
        } else {
            self.cameraDevice = .Front;
            flashButton.hidden = true
        }
    }
    
    // capture events
    
    func shouldTakePicture() {
        self.takePicture()
    }
    
    func shouldCaptureVideo() {
        if #available(iOS 10.0, *) {
            capturing = true
            self.startVideoCapture()
            checkTorchStatus()
        } else {
            overlayView.backgroundColor = UIColor.blackColor()
            self.mediaTypes = [kUTTypeMovie as String]
            self.cameraViewTransform = CGAffineTransformIdentity
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                self.capturing = true
                self.overlayView.backgroundColor = UIColor.clearColor()
                self.startVideoCapture()
                self.checkTorchStatus()
            })
        }
    }
    
    func checkTorchStatus() {
        // iOS always turn off torch before starting recording video
        if self.torchOn {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                if (self.capturing) {
                    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
                    if device .hasTorch && device.hasFlash {
                        try! device.lockForConfiguration()
                        device.torchMode = .On
                        device.flashMode = .On
                        device.unlockForConfiguration()
                    }
                }
            })
        }
    }
    
    func shouldStopCapturingVideo() {
        if capturing {
            self.stopVideoCapture()
            capturing = false
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        showPicker(0)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var info = info
        info["preferredWidth"] = squareView.preferredWidth
        
        let type = info[UIImagePickerControllerMediaType] as! String
        if type == (kUTTypeImage as String) {
            if self.sourceType == .Camera {
                let media = info[UIImagePickerControllerOriginalImage] as! UIImage
                let result = media.crop(UIScreen.mainScreen().bounds.size)
                info[UIImagePickerControllerOriginalImage] = result
                info["source"] = "camera"
            } else {
                info["source"] = "gallery"
            }
        }
        
        self.cameraDelegate?.cameraDidCaptureVideo(info)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {

        if self.sourceType == .Camera {
            self.showsCameraControls = false
        }
    }
    
}