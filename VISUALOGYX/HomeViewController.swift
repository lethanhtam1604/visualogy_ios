//
//  InspectionViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 9/25/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import MobileCoreServices
import AVFoundation
import SwiftOverlays

class HomeViewController: UIViewController, CameraControllerDelegate, CaptureButtonDelegate {
    var constraintsAdded = false
    var camera : CameraViewController!
    
    let preview = UIView()
    let imageView = UIImageView()
    let squareView = SquareView()
    let captureButton = CaptureButton()
    let overlayView = DrawingPad()
    let hintView = UIView()
    
    let hintIcon = UIImageView(image: UIImage(named: "click.png"))
    let hintAddLabel = UILabel()
    let hintRemoveLabel = UILabel()
    
    let menuButton = UIButton()
    let settingsButton = UIButton()
    
    // result variables
    
    var resultImage : UIImage?
    var imageData : NSData!
    
    // control variables
    
    var shouldShowCamera = true
    var shouldReopenCamera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.instance.requestLocation()
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        
        menuButton.setImage(UIImage(named: "menu.png"), forState: .Normal)
        menuButton.addTarget(self, action: #selector(showMenu), forControlEvents: .TouchUpInside)
        
        settingsButton.setImage(UIImage(named: "settings.png"), forState: .Normal)
        settingsButton.addTarget(self, action: #selector(settings), forControlEvents: .TouchUpInside)
        
        preview.hidden = true
        preview.backgroundColor = UIColor.blackColor()
        
        imageView.contentMode = .ScaleAspectFit
        overlayView.contentMode = .ScaleAspectFit
        
        hintView.hidden = true
        hintView.backgroundColor = UIColor.blackColor().alpha(0.5)
        hintView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHint)))
        
        hintIcon.contentMode = .ScaleAspectFit
        
        hintAddLabel.text = "Click on image to add pipes\nPinch to resize pines\nDrag to move pines"
        hintAddLabel.textColor = UIColor.whiteColor()
        hintAddLabel.textAlignment = .Center
        hintAddLabel.numberOfLines = 3
        hintAddLabel.adjustsFontSizeToFitWidth = true
        
        hintRemoveLabel.text = "Click on pipes to remove"
        hintRemoveLabel.textColor = UIColor.whiteColor()
        hintRemoveLabel.textAlignment = .Center
        hintRemoveLabel.adjustsFontSizeToFitWidth = true
        
        captureButton.delegate = self
        
        hintView.addSubview(hintIcon)
        hintView.addSubview(hintAddLabel)
        hintView.addSubview(hintRemoveLabel)
        
        preview.addSubview(imageView)
        preview.addSubview(overlayView)
        preview.addSubview(hintView)
        preview.addSubview(squareView)
        preview.addSubview(captureButton)
        
        view.addSubview(preview)
        view.addSubview(menuButton)
        view.addSubview(settingsButton)
        
        camera = CameraViewController()
        camera.cameraDelegate = self
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            preview.autoPinEdgesToSuperviewEdges()
            hintView.autoPinEdgesToSuperviewEdges()
            imageView.autoPinEdgesToSuperviewEdges()
            overlayView.autoPinEdgesToSuperviewEdges()
            squareView.autoPinEdgesToSuperviewEdges()
            
            hintIcon.autoAlignAxisToSuperviewAxis(.Vertical)
            hintIcon.autoAlignAxisToSuperviewAxis(.Horizontal)
            hintIcon.autoSetDimensionsToSize(CGSizeMake(50, 50))
            
            hintAddLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: hintView)
            hintAddLabel.autoSetDimension(.Height, toSize: 80)
            hintAddLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            hintAddLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: hintIcon, withOffset: 10)
            
            hintRemoveLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: hintView)
            hintRemoveLabel.autoSetDimension(.Height, toSize: 40)
            hintRemoveLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            hintRemoveLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: hintIcon, withOffset: 10)
            
            menuButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            menuButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            menuButton.autoSetDimension(.Width, toSize: 40)
            menuButton.autoSetDimension(.Height, toSize: 40)
            
            settingsButton.autoPinEdgeToSuperviewMargin(.Right)
            settingsButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            settingsButton.autoSetDimension(.Width, toSize: 40)
            settingsButton.autoSetDimension(.Height, toSize: 40)
            
            captureButton.autoAlignAxisToSuperviewAxis(.Vertical)
            captureButton.autoPinEdgeToSuperviewMargin(.Bottom)
            captureButton.autoSetDimension(.Width, toSize: 80)
            captureButton.autoSetDimension(.Height, toSize: 80)
        }
        super.updateViewConstraints()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showCamera()
        self.showOverlay()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        overlayView.type = nil
        overlayView.pendingPipe = nil
    }
    
    // actions
    
    func showMenu() {
        let showMenuBlock = {
            if let drawer = self.navigationController?.parentViewController as? DrawerViewController {
                drawer.showMenu()
            }
        }
        
        if shouldShowCamera {
            // dismiss camera before showing menu
            shouldShowCamera = false
            shouldReopenCamera = true
            camera.dismissViewControllerAnimated(false, completion: showMenuBlock)
        } else {
            showMenuBlock()
        }
    }
    
    func settings() {
        let settings = SettingViewController()
        self.navigationController?.pushViewController(settings, animated: true)
    }
    
    func showCamera() {
        if shouldShowCamera {
            settingsButton.hidden = true
            presentViewController(camera, animated: false, completion: nil)
        }
    }
    
    func hideHint() {
        self.hintView.hidden = true
    }
    
    func showOverlay() {
        let settings = NSUserDefaults.standardUserDefaults()
        var shouldShowHint = false
        
        if overlayView.type == PipeType.Added {
            hintAddLabel.hidden = false
            hintRemoveLabel.hidden = true
            
            shouldShowHint = !settings.boolForKey("hintAdd")
            settings.setBool(true, forKey: "hintAdd")
            settings.synchronize()
        }
        
        if overlayView.type == PipeType.Removed {
            hintAddLabel.hidden = true
            hintRemoveLabel.hidden = false
            
            shouldShowHint = !settings.boolForKey("hintRemove")
            settings.setBool(true, forKey: "hintRemove")
            settings.synchronize()
        }
        
        if !shouldShowHint {
            return
        }
        
        if overlayView.type != nil {
            
            hintView.alpha = 0
            hintView.hidden = false
            UIView.animateWithDuration(0.2, animations: {
                self.hintView.alpha = 1
                }, completion: {
                    _ in
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue(), {
                        UIView.animateWithDuration(0.2, animations: {
                            self.hintView.alpha = 0
                            }, completion: {
                                _ in
                                self.hintView.hidden = true
                        })
                    })
                    
            })
        }
    }
    
    // preview
    
    func cameraDidCaptureVideo(info: [String : AnyObject]) {
        shouldShowCamera = false
        camera.dismissViewControllerAnimated(false, completion: {
            self.showPreview(info)
        })
    }
    
    func showPreview(info: [String : AnyObject]) {
        SwiftOverlays.showBlockingWaitOverlay()
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            let type = info[UIImagePickerControllerMediaType] as! String
            //            let input =  NSTemporaryDirectory().stringByAppendingString("input.jpg")
            //            let output = NSTemporaryDirectory().stringByAppendingString("output.jpg")
            
            if type == (kUTTypeMovie as String) {
                self.resultImage = UIImage(named: "panorama.png")
            } else {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                self.imageData = UIImageJPEGRepresentation(image.resize(Global.imageSize), 1)
                self.resultImage = UIImage(data: self.imageData)
                self.overlayView.backgroundImage = self.resultImage
                
                if (info["source"] as! String) == "camera" {
                    let width = info["preferredWidth"] as! CGFloat
                    self.postImage(width)
                } else {
                    self.displayPreview(true)
                }
            }
        })
    }
    
    func displayPreview(edit: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            SwiftOverlays.removeAllBlockingOverlays()
            self.overlayView.hidden = false
            self.imageView.image = self.resultImage
            self.settingsButton.hidden = edit
            self.captureButton.hidden = !edit
            self.squareView.hidden = !edit
            self.squareView.moveSquareToCenter()
            self.preview.hidden = false
            
            self.preview.transform = CGAffineTransformMakeScale(0.01, 0.01)
            
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
                self.preview.transform = CGAffineTransformIdentity
                }, completion: {
                    _ in
            })
        })
    }
    
    // capture actions
    
    func shouldTakePicture() {
        SwiftOverlays.showBlockingWaitOverlay()
        postImage(squareView.preferredWidth)
    }
    
    func shouldCaptureVideo() {
        
    }
    
    func shouldStopCapturingVideo() {
        SwiftOverlays.showBlockingWaitOverlay()
        postImage(squareView.preferredWidth)
    }
    
    // networking
    
    func postImage(width: CGFloat) {
        let email = Global.user.email!

        Global.client.POST("http://139.59.10.243/vlapi/process_image",
                           parameters: [
                            "email": email,
                            "tag_description": self.overlayView.convertDimensionToImage(width),
                            "training_image_file_name": "testfile.jpg",
                            "training_image_file_data": imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))] as NSDictionary,
                           progress:nil,
                           success: {
                            (task, response) in
                            print(response)
                            var result = [Pipe]()
                            
                            if let response = response as? [String : String] {
                                if let pipeStr = response["error_description"] {
                                    
                                    var shouldStop = false
                                    var shouldCount = false
                                    var shouldAcceptX = false
                                    var shouldAcceptY = false
                                    var shouldAcceptRadius = false
                                    var value = ""
                                    var pipe : Pipe!
                                    
                                    for token in pipeStr.unicodeScalars {
                                        if shouldStop {
                                            break
                                        }
                                        
                                        switch token {
                                        case "]":
                                            shouldStop = true
                                        case "(":
                                            if !shouldCount {
                                                shouldCount = true
                                                pipe = Pipe()
                                                pipe.type = .Detected
                                            } else {
                                                shouldAcceptX = true
                                            }
                                            value.removeAll()
                                        case ")":
                                            if shouldAcceptRadius {
                                                shouldAcceptRadius = false
                                            } else {
                                                shouldCount = false
                                            }
                                        case "0"..."9", ".":
                                            value.append(token)
                                            
                                        case ",":
                                            let v = CGFloat(Double(value)!)
                                            if shouldAcceptX {
                                                pipe.center = CGPointMake(v, pipe.y)
                                                shouldAcceptX = false
                                                shouldAcceptY = true
                                            } else if shouldAcceptY {
                                                pipe.center = CGPointMake(pipe.x, v)
                                                shouldAcceptY = false
                                                shouldAcceptRadius = true
                                            } else if shouldAcceptRadius {
                                                pipe.radius = self.overlayView.convertDimensionToView(v)
                                                shouldAcceptRadius = false
                                                result.append(pipe)
                                            } else if shouldCount {
                                                pipe.id = Int(v)
                                            }
                                            value.removeAll()
                                            
                                        default:
                                            break
                                        }
                                    }
                                }
                            }
                            
                            //            UIImageJPEGRepresentation(self.resultImage!, 1)!.writeToFile(input, atomically:true)
                            //            Processor.ProcessImageWithInFile(input, outFile: output)
                            //            self.resultImage = UIImage(contentsOfFile: output)
                            
                            self.overlayView.pipes = result
                            self.overlayView.drawOverlay()
                            self.displayPreview(false)
            }, failure: {
                (task, error) in
                SwiftOverlays.removeAllBlockingOverlays()
                print(error)
                let alert = UIAlertController(title: "Error",
                    message: "Cannot upload image. Please try again!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}