//
//  RequestViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/6/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import MapKit
import FontAwesomeKit
import SwiftOverlays

enum Request {
    case Add
    case Edit
    case Copy
}

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let nameField = UITextField()
    
    let imageContainter = UIView()
    let imageButton = UIButton()
    let imageView = UIView()
    let imageHolder = AsyncImageView()
    let addButton = UIButton()
    let removeButton  = UIButton()
    
    let inspectorContainter = UIView()
    let inspectorButton = UIButton()
    let inspectorTable = UITableView()
    
    let windowContainter = UIView()
    let windowButton = UIButton()
    let windowView = UIView()
    let fromLabel = UILabel()
    let fromField = UIButton()
    let toLabel = UILabel()
    let toField = UIButton()
    
    let locationContainter = UIView()
    let locationButton = UIButton()
    let mapView = MKMapView()
    var anotation = MKPointAnnotation()
    
    let gradientBackground = GradientView()
    let doneButton = UIButton()
    let cancelButton = UIButton()
    
    let locationManager = CLLocationManager()
    
    var constraintsAdded = false
    var heightContraints = [NSLayoutConstraint]()
    var containerContraints = [NSLayoutConstraint]()
    var containers : [UIView]!
    var buttons : [UIButton]!
    var views : [UIView]!
    let heights : [CGFloat] = [200, 300, 150, 300]
    
    
    var image : UIImage? {
        didSet {
            if let image = image {
                imageHolder.image = image
                addButton.hidden = true
                removeButton.hidden = false
            } else {
                addButton.hidden = false
                removeButton.hidden = true
                imageHolder.image = nil
            }
        }
    }
    
    var inspector : User? {
        didSet {
            if let inspector = inspector {
                inspectorButton.setTitle(" \(inspector.username!)", forState: .Normal)
            } else {
                inspectorButton.setTitle(" Inspector", forState: .Normal)
            }
        }
    }
    
    var fromDate : NSDate? {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            
            if fromDate != nil {
                fromField.setTitle(dateFormatter.stringFromDate(fromDate!), forState: .Normal)
            } else {
                fromField.setTitle(dateFormatter.stringFromDate(NSDate()), forState: .Normal)
            }
        }
    }
    
    var toDate : NSDate? {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            
            if toDate != nil {
                toField.setTitle(dateFormatter.stringFromDate(toDate!), forState: .Normal)
            } else {
                toField.setTitle(dateFormatter.stringFromDate(NSDate()), forState: .Normal)
            }
        }
    }
    
    var request = Request.Add
    var inspection : Inspection? {
        didSet {
            image = nil
            fromDate = NSDate()
            toDate = NSDate()
            
            if let inspection = inspection {
                nameField.text = inspection.type
                fromDate = inspection.startDate
                toDate = inspection.endDate
                
                if let location = inspection.location  {
                    if !location.isEmpty {
                        let locs = location.characters.split{$0 == ","}.map(String.init)
                        
                        if let lat = Double(locs[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                            ) {
                            if let lon = Double(locs[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                                ) {
                                customLocation = true
                                mapView.hidden = false
                                
                                anotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
                                
                                var mapRegion = MKCoordinateRegion()
                                mapRegion.center = anotation.coordinate
                                mapRegion.span.latitudeDelta = 0.002
                                mapRegion.span.longitudeDelta = 0.002
                                mapView.setRegion(mapRegion, animated: true)
                            }
                        }
                    }
                }
                
                if let image = inspection.image {
                    if let url = NSURL(string: image) {
                        SwiftOverlays.showBlockingWaitOverlay()
                        AsyncImageLoader.sharedLoader().loadImageWithURL(url, target: self, success: #selector(imageLoaded), failure: #selector(imageLoadFailed))
                    }
                } else {
                    image = nil
                }

                
            }
        }
    }
    
    func imageLoadFailed() {
        SwiftOverlays.removeAllBlockingOverlays()
        image = nil
    }
    
    func imageLoaded(image: UIImage, url: NSURL) {
        SwiftOverlays.removeAllBlockingOverlays()
        self.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(nameField)
        containerView.addSubview(imageContainter)
        containerView.addSubview(inspectorContainter)
        containerView.addSubview(windowContainter)
        containerView.addSubview(locationContainter)
        containerView.addSubview(doneButton)
        containerView.addSubview(cancelButton)
        
        imageContainter.addSubview(imageButton)
        imageContainter.addSubview(imageView)
        imageContainter.addSubview(addButton)
        imageContainter.addSubview(removeButton)
        
        inspectorContainter.addSubview(inspectorButton)
        inspectorContainter.addSubview(inspectorTable)
        
        windowContainter.addSubview(windowButton)
        windowContainter.addSubview(windowView)
        
        locationContainter.addSubview(locationButton)
        locationContainter.addSubview(mapView)
        
        windowView.addSubview(fromLabel)
        windowView.addSubview(fromField)
        windowView.addSubview(toLabel)
        windowView.addSubview(toField)
        
        imageView.addSubview(imageHolder)
        imageView.addSubview(addButton)
        imageView.addSubview(removeButton)
        
        imageButton.setImage(UIImage(named: "add-image.png"), forState: .Normal)
        imageButton.setTitle(" Image", forState: .Normal)
        imageButton.addTarget(self, action: #selector(toggleView), forControlEvents: .TouchUpInside)
        
        inspectorButton.setImage(UIImage(named: "add-inspector.png"), forState: .Normal)
        inspectorButton.setTitle(" Inspector", forState: .Normal)
        inspectorButton.addTarget(self, action: #selector(toggleView), forControlEvents: .TouchUpInside)
        
        windowButton.setImage(UIImage(named: "add-window.png"), forState: .Normal)
        windowButton.setTitle(" Window", forState: .Normal)
        windowButton.addTarget(self, action: #selector(toggleView), forControlEvents: .TouchUpInside)
        
        locationButton.setImage(UIImage(named: "location.png"), forState: .Normal)
        locationButton.setTitle(" Location", forState: .Normal)
        locationButton.addTarget(self, action: #selector(toggleView), forControlEvents: .TouchUpInside)
        
        nameField.backgroundColor = Global.colorBg
        nameField.layer.cornerRadius = 5
        nameField.clipsToBounds = true
        nameField.tintColor = Global.colorSecond
        nameField.delegate = self
        nameField.placeholder = "Request name..."
        nameField.textAlignment = .Center
        nameField.textColor = Global.colorSelected
        
        containers = [imageContainter, inspectorContainter, windowContainter, locationContainter]
        for view in containers {
            view.backgroundColor = Global.colorBg
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
        }
        
        buttons = [imageButton, inspectorButton, windowButton, locationButton]
        for button in buttons {
            button.imageView?.contentMode = .ScaleAspectFit
            button.titleLabel?.textAlignment = .Left
            button.setTitleColor(Global.colorSelected, forState: .Normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        views = [imageView, inspectorTable, windowView, mapView]
        for view in views {
            view.backgroundColor = UIColor.whiteColor()
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
        }
        
        imageHolder.contentMode = .ScaleAspectFill
        
        addButton.setImage(UIImage(named: "add-request.png"), forState: .Normal)
        addButton.setTitle("Add", forState: .Normal)
        addButton.addTarget(self, action: #selector(addImage), forControlEvents: .TouchUpInside)
        
        let removeIcon = FAKFontAwesome.removeIconWithSize(30)
        removeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let removeImg  = removeIcon.imageWithSize(CGSizeMake(30, 30))
        removeButton.setImage(removeImg, forState: .Normal)
        removeButton.setTitle("Remove", forState: .Normal)
        removeButton.addTarget(self, action: #selector(removeImage), forControlEvents: .TouchUpInside)
        
        for button in [addButton, removeButton] {
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.imageView?.contentMode = .ScaleAspectFit
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.titleLabel?.textAlignment = .Center
            button.setTitleColor(Global.colorSelected, forState: .Normal)
        }
        removeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        inspectorTable.delegate = self
        inspectorTable.dataSource = self
        inspectorTable.rowHeight = 60
        
        fromLabel.text = "From: "
        fromLabel.adjustsFontSizeToFitWidth = true
        fromLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        fromLabel.textColor = Global.colorSelected
        fromLabel.textAlignment = .Left
        
        toLabel.text = "To: "
        toLabel.adjustsFontSizeToFitWidth = true
        toLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        toLabel.textColor = Global.colorSelected
        toLabel.textAlignment = .Left
        
        for field in [fromField, toField] {
            field.backgroundColor = Global.colorBg
            field.layer.cornerRadius = 5
            field.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            field.setTitleColor(Global.colorSelected, forState: .Normal)
            field.addTarget(self, action: #selector(changeDate), forControlEvents: .TouchUpInside)
        }
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeLocation)))
        mapView.addAnnotation(anotation)
        
        doneButton.layer.cornerRadius = 5
        doneButton.clipsToBounds = true
        doneButton.setTitle("Create", forState: .Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.titleLabel?.backgroundColor = UIColor.clearColor()
        doneButton.insertSubview(gradientBackground, atIndex: 0)
        doneButton.addTarget(self, action: #selector(create), forControlEvents: .TouchUpInside)
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        cancelButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.titleLabel?.backgroundColor = UIColor.clearColor()
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Global.colorSecond.CGColor
        cancelButton.addTarget(self, action: #selector(cancel), forControlEvents: .TouchUpInside)
        
        switch request {
        case .Add:
            self.title = "New Request"
        case .Edit:
            self.title = "Edit Request"
        case .Copy:
            self.title = "Copy Request"
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        self.view.setNeedsUpdateConstraints()
        
        Global.client.GET("get_inspectors",
                          parameters: nil,
                          progress:nil,
                          success: {
                            (task, response) in
                            self.inspectors.removeAll()
                            if let response = response as? [[String : AnyObject]] {
                                for inspector in response {
                                    let user = User(response: inspector)
                                    self.inspectors.append(user)
                                    if let inspection = self.inspection {
                                        if let name = inspection.inspector {
                                            if name == user.email! {
                                                self.inspector = user
                                            }
                                        }
                                    }
                                }
                            }
                            self.inspectorTable.reloadData()
            }, failure: {
                (task, error) in
                let alert = UIAlertController(title: "Error",
                    message: "Can't fetch list of inspectors. Please try again!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            for i in 0..<4 {
                let button = buttons[i]
                let view = views[i]
                let container = containers[i]
                
                button.autoPinEdgeToSuperviewEdge(.Left)
                button.autoPinEdgeToSuperviewEdge(.Right)
                button.autoPinEdgeToSuperviewEdge(.Top)
                button.autoSetDimension(.Height, toSize: 40)
                
                button.imageView?.autoSetDimensionsToSize(CGSizeMake(25, 25))
                button.imageView?.autoAlignAxisToSuperviewAxis(.Horizontal)
                button.imageView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 15)
                
                button.titleLabel?.autoAlignAxisToSuperviewAxis(.Horizontal)
                button.titleLabel?.autoPinEdgeToSuperviewEdge(.Right)
                button.titleLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: button, withOffset: 60)
                
                view.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
                view.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
                view.autoPinEdgeToSuperviewEdge(.Top, withInset: 40)
                view.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
                let height = view.autoSetDimension(.Height, toSize: 0)
                
                container.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
                container.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
                let containerHeight = container.autoMatchDimension(.Height, toDimension: .Height, ofView: view, withOffset: 40)
                
                heightContraints.append(height)
                containerContraints.append(containerHeight)
            }
            
            nameField.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            nameField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            nameField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            nameField.autoSetDimension(.Height, toSize: 40)
            
            imageContainter.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameField, withOffset: 10)
            inspectorContainter.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageContainter, withOffset: 10)
            windowContainter.autoPinEdge(.Top, toEdge: .Bottom, ofView: inspectorContainter, withOffset: 10)
            locationContainter.autoPinEdge(.Top, toEdge: .Bottom, ofView: windowContainter, withOffset: 10)
            
            doneButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            doneButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            doneButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: locationContainter, withOffset: 20)
            doneButton.autoSetDimension(.Height, toSize: 40)
            
            gradientBackground.autoPinEdgesToSuperviewEdges()
            
            cancelButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            cancelButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: doneButton, withOffset: 10)
            cancelButton.autoSetDimension(.Height, toSize: 40)
            
            imageHolder.autoPinEdgesToSuperviewEdges()
            
            for button in [addButton, removeButton] {
                button.autoSetDimensionsToSize(CGSizeMake(70, 70))
                button.autoCenterInSuperview()
                
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
            
            fromLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            fromLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            fromLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            fromLabel.autoSetDimension(.Height, toSize: 20)
            
            fromField.autoPinEdge(.Top, toEdge: .Bottom, ofView: fromLabel, withOffset: 5)
            fromField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            fromField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            fromField.autoSetDimension(.Height, toSize: 30)
            
            toLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: fromField, withOffset: 10)
            toLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            toLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            toLabel.autoSetDimension(.Height, toSize: 20)
            
            toField.autoPinEdge(.Top, toEdge: .Bottom, ofView: toLabel, withOffset: 5)
            toField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            toField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            toField.autoSetDimension(.Height, toSize: 30)
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
        var height : CGFloat = 200
        for heightConstraint in heightContraints {
            height += heightConstraint.constant
        }
        for containerHeight in containerContraints {
            height += containerHeight.constant
        }
        
        containerView.frame = CGRectMake(0, 0, view.frame.width, height)
        scrollView.contentSize = containerView.bounds.size
    }
    
    // textfield
    
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        textField.enabled = false
    //
    //        textButton.enabled = true
    //        return true
    //    }
    //
    //    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    //        return true
    //    }
    
    // actions
    
    func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func removeImage() {
        image = nil
        toggleView(imageButton)
    }
    
    func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func create() {
        if let image = image {
            if let inspector = inspector {
                
                if anotation.coordinate.latitude == 0 && anotation.coordinate.longitude == 0 {
                    let alert = UIAlertController(title: "Error",
                                                  message: "Invalid location!",
                                                  preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                SwiftOverlays.showBlockingWaitOverlay()
                
                let email = Global.user.email!
                
                //Compress the image
                var compression : CGFloat = 0.9
                let maxCompression : CGFloat = 0.1
                
                var imageData : NSData! = UIImageJPEGRepresentation(image, compression);
                
                while (imageData.length > 1024 * 1024 && compression > maxCompression) {
                    compression -= 0.05
                    imageData = UIImageJPEGRepresentation(image, compression);
                }
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMddyyyy"
                
                let startDate = fromDate == nil ? "" : formatter.stringFromDate(fromDate!)
                let endDate = toDate == nil ? "" : formatter.stringFromDate(toDate!)
                
                let param = [
                    "name": nameField.text!,
                    "manager_name": email,
                    "inspector_name": inspector.email!,
                    "location": "\(anotation.coordinate.latitude),\(anotation.coordinate.longitude)",
                    "start_date": startDate,
                    "end_date": endDate,
                    "reference_image_file_name": "request.jpg",
                    "reference_image_file_data": imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))]
                // print(param)
                
                Global.client.POST("new_request",
                                   parameters: param as NSDictionary,
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
                                              message: "Please select an inspector",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Please select an image first",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // toggle
    
    func toggleView(sender: UIButton) {
        var button : UIButton!
        var heightConstraint : NSLayoutConstraint!
        var containerConstraint : NSLayoutConstraint!
        var height : CGFloat!
        for i in 0..<4 {
            button = buttons[i]
            heightConstraint = heightContraints[i]
            containerConstraint = containerContraints[i]
            height = heights[i]
            
            if button == sender {
                break
            }
        }
        
        if heightConstraint.constant == 0 {
            containerConstraint.constant = 50
            heightConstraint.constant = height
        } else {
            containerConstraint.constant = 40
            heightConstraint.constant = 0
            
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                _ in
                self.refreshView()
        })
        
    }
    
    // image picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // table view
    
    var inspectors = [User]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspectors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var inspectionCell : UserCell!
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UserCell {
            inspectionCell = cell
        } else {
            inspectionCell = UserCell(style: .Default, reuseIdentifier: "cell")
        }
        
        inspectionCell.inspector = inspectors[indexPath.row]
        return inspectionCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        inspector = inspectors[indexPath.row]
        toggleView(inspectorButton)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // map
    var customLocation = false
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if !customLocation {
            var mapRegion = MKCoordinateRegion()
            anotation.coordinate = mapView.userLocation.coordinate
            mapRegion.center = mapView.userLocation.coordinate
            mapRegion.span.latitudeDelta = 0.002
            mapRegion.span.longitudeDelta = 0.002
            mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != .AuthorizedAlways && status != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func changeLocation(gestureRecognizer: UIGestureRecognizer) {
        customLocation = true
        let touchPoint = gestureRecognizer.locationInView(mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        anotation.coordinate = touchMapCoordinate
    }
    
    func changeDate(sender: UIButton) {
        var date: NSDate!
        if sender == fromField {
            date = fromDate
        } else {
            date = toDate
        }
        
        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.pickerWithDate(date, selectedBlock: {
            newDate in
            if sender == self.fromField {
                self.fromDate = newDate
            } else {
                self.toDate = newDate
            }
            datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
            
            }, cancelBlock: {
                datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
        }) as! UIViewController
        
        presentViewController(datePickerViewController, animated: true, completion: nil)
    }
}
