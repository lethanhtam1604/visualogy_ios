//
//  TrainingViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import SwiftOverlays

class TrainingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, RevealViewDelegate {
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let gradientView = GradientView()
    let titleField = UITextField()
    
    let imageView = UIImageView()
    let overlayView = DrawingPad()
    let cropView = UIImageView()
    let addButton = UIButton()
    
    let toolLabel = UILabel()
    let toolView = StackView()
    let shapeButton = UIButton()
    let brushButton = UIButton()
    let textButton = UIButton()
    let cropButton = UIButton()
    
    let shapeView = RevealView()
    let brushView = RevealView()
    
    let gradientBackground = GradientView()
    let doneButton = UIButton()
    
    let brushRed = UIButton()
    let brushGreen = UIButton()
    let brushBlue = UIButton()
    
    let shapeCircle = UIButton()
    let shapeSquare = UIButton()
    let shapeTriangle = UIButton()
    
    var constraintsAdded = false
    var imageHeightContraint : NSLayoutConstraint!
    
    var image : UIImage? {
        didSet {
            if let image = image {
                overlayView.hidden = false
                overlayView.backgroundImage = image
                imageView.image = image
                addButton.hidden = true
            } else {
                overlayView.hidden = true
                addButton.hidden = false
                imageView.image = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        
        self.title = "Training Mode"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = false
        self.edgesForExtendedLayout = .None
        
        let menuIcon = FAKIonIcons.androidMenuIconWithSize(30)
        menuIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let menuImg  = menuIcon.imageWithSize(CGSizeMake(30, 30))
        let menuButton = UIBarButtonItem(image: menuImg, style: .Plain, target: self, action: #selector(showMenu))
        self.navigationItem.leftBarButtonItem = menuButton
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(gradientView)
        containerView.addSubview(titleField)
        containerView.addSubview(imageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(cropView)
        containerView.addSubview(addButton)
        containerView.addSubview(toolLabel)
        containerView.addSubview(brushView)
        containerView.addSubview(shapeView)
        containerView.addSubview(toolView)
        containerView.addSubview(doneButton)
        
        toolView.addSubview(shapeButton)
        toolView.addSubview(brushButton)
        toolView.addSubview(textButton)
        toolView.addSubview(cropButton)
        
        titleField.borderStyle = .None
        titleField.tintColor = UIColor.whiteColor()
        titleField.delegate = self
        titleField.enabled = false
        titleField.textAlignment = .Center
        titleField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleField.textColor = UIColor.whiteColor()
        titleField.text = "Editor"
        
        imageView.backgroundColor = Global.colorBg
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        overlayView.contentMode = .ScaleAspectFill
        
        addButton.setImage(UIImage(named: "add-request.png"), forState: .Normal)
        addButton.setTitle("Add Image", forState: .Normal)
        addButton.addTarget(self, action: #selector(addImage), forControlEvents: .TouchUpInside)
        
        toolLabel.text = "TOOLS"
        toolLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        toolLabel.adjustsFontSizeToFitWidth = true
        toolLabel.textColor = Global.colorSecond
        toolLabel.textAlignment = .Center
        
        shapeButton.setImage(UIImage(named: "shapes.png"), forState: .Normal)
        shapeButton.setTitle("Add Shape", forState: .Normal)
        shapeButton.addTarget(self, action: #selector(addShape), forControlEvents: .TouchUpInside)
        
        brushButton.setImage(UIImage(named: "brush.png"), forState: .Normal)
        brushButton.setTitle("Brush", forState: .Normal)
        brushButton.addTarget(self, action: #selector(brush), forControlEvents: .TouchUpInside)
        
        textButton.setImage(UIImage(named: "text.png"), forState: .Normal)
        textButton.setTitle("Text", forState: .Normal)
        textButton.addTarget(self, action: #selector(text), forControlEvents: .TouchUpInside)
        
        cropButton.setImage(UIImage(named: "crop.png"), forState: .Normal)
        cropButton.setTitle("Crop", forState: .Normal)
        cropButton.addTarget(self, action: #selector(crop), forControlEvents: .TouchUpInside)
        
        
        brushRed.setImage(UIImage(named: "red.png"), forState: .Normal)
        brushRed.setTitle("Red", forState: .Normal)
        
        brushGreen.setImage(UIImage(named: "green.png"), forState: .Normal)
        brushGreen.setTitle("Green", forState: .Normal)
        
        brushBlue.setImage(UIImage(named: "blue.png"), forState: .Normal)
        brushBlue.setTitle("Blue", forState: .Normal)
        
        shapeCircle.setImage(UIImage(named: "circle.png"), forState: .Normal)
        shapeCircle.setTitle("Circle", forState: .Normal)
        
        shapeTriangle.setImage(UIImage(named: "triangle.png"), forState: .Normal)
        shapeTriangle.setTitle("Triangle", forState: .Normal)
        
        shapeSquare.setImage(UIImage(named: "square.png"), forState: .Normal)
        shapeSquare.setTitle("Square", forState: .Normal)
        
        for button in [addButton, shapeButton, brushButton, textButton, cropButton,
                       brushRed, brushBlue, brushGreen,
                       shapeSquare, shapeTriangle, shapeCircle] {
                        button.backgroundColor = Global.colorBg
                        button.layer.cornerRadius = 5
                        button.clipsToBounds = true
                        button.imageView?.contentMode = .ScaleAspectFit
                        button.titleLabel?.font = UIFont.systemFontOfSize(12)
                        button.titleLabel?.textAlignment = .Center
                        button.setTitleColor(Global.colorSelected, forState: .Normal)
        }
        
        brushView.views = [brushRed, brushGreen, brushBlue]
        brushView.anchorView = brushButton
        brushView.delegate = self
        
        shapeView.views = [shapeCircle, shapeTriangle, shapeSquare]
        shapeView.anchorView = shapeButton
        shapeView.delegate = self
        
        doneButton.layer.cornerRadius = 5
        doneButton.clipsToBounds = true
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.titleLabel?.backgroundColor = UIColor.clearColor()
        doneButton.insertSubview(gradientBackground, atIndex: 0)
        doneButton.addTarget(self, action: #selector(done), forControlEvents: .TouchUpInside)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            gradientView.autoPinEdgeToSuperviewEdge(.Left)
            gradientView.autoPinEdgeToSuperviewEdge(.Right)
            gradientView.autoPinEdgeToSuperviewEdge(.Top)
            gradientView.autoSetDimension(.Height, toSize: 80)
            
            titleField.autoPinEdgeToSuperviewEdge(.Left)
            titleField.autoPinEdgeToSuperviewEdge(.Right)
            titleField.autoPinEdgeToSuperviewEdge(.Top)
            titleField.autoSetDimension(.Height, toSize: 80)
            
            imageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            imageView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            imageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: gradientView, withOffset: 5)
            imageHeightContraint = imageView.autoSetDimension(.Height, toSize: 300)
            
            overlayView.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            overlayView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: imageView)
            overlayView.autoPinEdge(.Top, toEdge: .Top, ofView: imageView)
            overlayView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: imageView)
            
            addButton.autoSetDimensionsToSize(CGSizeMake(70, 70))
            addButton.autoAlignAxis(.Vertical, toSameAxisOfView: imageView)
            addButton.autoAlignAxis(.Horizontal, toSameAxisOfView: imageView)
            
            toolLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageView, withOffset: 5)
            toolLabel.autoSetDimension(.Height, toSize: 60)
            toolLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            toolLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            
            toolView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            toolView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            toolView.autoPinEdge(.Top, toEdge: .Bottom, ofView: toolLabel, withOffset: 5)
            toolView.autoSetDimension(.Height, toSize: 70)
            
            doneButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            doneButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            doneButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: toolView, withOffset: 15)
            doneButton.autoSetDimension(.Height, toSize: 40)
            
            gradientBackground.autoPinEdgesToSuperviewEdges()
            
            for button in [addButton, shapeButton, brushButton, textButton, cropButton,
                           brushGreen, brushRed, brushBlue,
                           shapeSquare, shapeTriangle, shapeCircle] {
                            button.titleLabel?.autoPinEdgeToSuperviewEdge(.Bottom)
                            button.titleLabel?.autoPinEdgeToSuperviewEdge(.Left)
                            button.titleLabel?.autoPinEdgeToSuperviewEdge(.Right)
                            button.titleLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 50)
                            button.titleLabel?.autoSetDimension(.Height, toSize: 20)
                            
                            button.imageView?.autoPinEdgeToSuperviewEdge(.Right)
                            button.imageView?.autoPinEdgeToSuperviewEdge(.Left)
                            button.imageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 25)
                            button.imageView?.autoSetDimension(.Height, toSize: 35)
            }
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }
    
    func refreshView() {
        var height : CGFloat = 80 + 5 + 5 + 60 + 5 + 70 + 15 + 40 + 20
        if image == nil {
            imageHeightContraint.constant = 300
        } else {
            //            let imageHeight = imageView.frame.width / image!.size.width * image!.size.height
            //            imageHeightContraint.constant = imageHeight
            imageHeightContraint.constant = 300
        }
        
        height += imageHeightContraint.constant
        containerView.frame = CGRectMake(0, 0, view.frame.width, height)
        scrollView.contentSize = containerView.bounds.size
    }
    
    // textfield
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.enabled = false
        
        textButton.enabled = true
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    // actions
    
    func showMenu() {
        if let drawer = self.navigationController?.parentViewController as? DrawerViewController {
            drawer.showMenu()
        }
    }
    
    func addImage() {
        dismissPopup()
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func addShape() {
        if image == nil {
            return
        }
        
        dismissPopup()
        
        if shapeView.showing {
            shapeView.hide()
        } else {
            shapeView.show()
        }
    }
    
    func brush() {
        if image == nil {
            return
        }
        
        dismissPopup()
        
        if brushView.showing {
            brushView.hide()
        } else {
            brushView.show()
        }
    }
    
    func text() {
        if image == nil {
            return
        }
        
        dismissPopup()
        
        if titleField.text == "Editor" {
            titleField.text = ""
        }
        titleField.enabled = true
        titleField.becomeFirstResponder()
        textButton.enabled = false
    }
    
    func crop() {
        if image == nil {
            return
        }
        
        dismissPopup()
    }
    
    func done() {
        if titleField.text == nil || titleField.text!.isEmpty || titleField.text! == "Editor" {
            let alert = UIAlertController(title: "Error",
                                          message: "Please input description text!",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if let origin = image {
            SwiftOverlays.showBlockingWaitOverlay()
            
            let email = Global.user.email!
            var image = origin

            if let overlay = overlayView.overlayImage {
                image = origin.merge(overlay, alpha: overlayView.alpha)
            }
            
            let imageData = UIImageJPEGRepresentation(image.resize(Global.imageSize), 1)!
            
            Global.client.POST("post_training_image",
                              parameters: [
                                "email": email,
                                "tag_description": titleField.text!,
                                "training_image_file_name": "testfile.jpg",
                                "training_image_file_data": imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))] as NSDictionary,
                              progress:nil,
                              success: {
                                (task, response) in
                                print(response)
                                
                                SwiftOverlays.removeAllBlockingOverlays()

                                if let drawer = self.navigationController?.parentViewController as? DrawerViewController {
                                    UIView.animateWithDuration(0.5, animations: {
                                        self.view.window?.alpha = 0
                                        }, completion: {
                                            _ in
                                            self.view.window?.alpha = 1
                                            drawer.select(.Home)
                                    })
                                }
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

        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Please select an image first!",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func dismissPopup() {
        brushView.hide()
        shapeView.hide()
    }
    
    // image picker
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // popup
    
    func revealViewDidHide() {
        
    }
    
    func revealViewDidShow() {
        
    }
    
    func revealViewSelectionDidChange(revealView: RevealView, index: Int, view: UIView) {
        if revealView == brushView {
            switch index {
            case 0:
                overlayView.color = UIColor.redColor()
                overlayView.drawOverlay()
            case 1:
                overlayView.color = UIColor.greenColor()
                overlayView.drawOverlay()
            case 2:
                overlayView.color = UIColor.blueColor()
                overlayView.drawOverlay()
            default:
                break
            }
        } else {
            switch index {
            case 0:
                overlayView.pendingPipe = nil
                overlayView.type = PipeType.Circle
            case 1:
                overlayView.pendingPipe = nil
                overlayView.type = PipeType.Triangle
            case 2:
                overlayView.pendingPipe = nil
                overlayView.type = PipeType.Square
            default:
                break
            }
        }
    }
}
