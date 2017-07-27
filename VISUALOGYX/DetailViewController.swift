//
//  DetailViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/4/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import MapKit
import FontAwesomeKit
import CNPPopupController

class DetailViewController: UIViewController {
    let scrollView = UIScrollView()
    
    let imageView = AsyncImageView(frame: CGRectZero)
    let typeLabel = UILabel()
    let countLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    let descriptionLabel = UILabel()
    let mapView = MKMapView()
    
    
    var constraintsAdded = false
    var imageHeightConstraint : NSLayoutConstraint!
    var descHeightConstraint : NSLayoutConstraint!
    var popup : CNPPopupController?
    
    var inspection : Inspection!
    var managerMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        if managerMode {
            let optionIcon = FAKFontAwesome.gearIconWithSize(30)
            optionIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            let optionImg  = optionIcon.imageWithSize(CGSizeMake(30, 30))
            let optionButton = UIBarButtonItem(image: optionImg, style: .Plain, target: self, action: #selector(showActions))
            self.navigationItem.rightBarButtonItem = optionButton
        }
        
        scrollView.showsHorizontalScrollIndicator = false
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.backgroundColor = Global.colorBg
        
        typeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.numberOfLines = 1
        typeLabel.textColor = UIColor.darkGrayColor()
        
        countLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.numberOfLines = 1
        countLabel.textColor = UIColor.darkGrayColor()
        
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .Right
        dateLabel.textColor = UIColor.darkGrayColor()
        
        timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.numberOfLines = 1
        timeLabel.textAlignment = .Right
        timeLabel.textColor = UIColor.darkGrayColor()
        
        descriptionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        descriptionLabel.numberOfLines = 2048
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.textAlignment = .Left
        descriptionLabel.textColor = UIColor.darkGrayColor()
        
        mapView.backgroundColor = Global.colorBg
        mapView.hidden = true
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(typeLabel)
        scrollView.addSubview(countLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(mapView)
        
        view.addSubview(scrollView)
        
        loadData()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let margin : CGFloat = 10
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            imageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            imageView.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            imageView.autoAlignAxisToSuperviewAxis(.Vertical)
            imageHeightConstraint = imageView.autoSetDimension(.Height, toSize: 250)
            
            typeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            typeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageView, withOffset: 10)
            typeLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            typeLabel.autoSetDimension(.Height, toSize: 18)
            
            countLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            countLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: typeLabel, withOffset: 5)
            countLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            countLabel.autoSetDimension(.Height, toSize: 18)
            
            dateLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            dateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageView, withOffset: 12)
            dateLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            dateLabel.autoSetDimension(.Height, toSize: 16)
            
            timeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            timeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: typeLabel, withOffset: 7)
            timeLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            timeLabel.autoSetDimension(.Height, toSize: 16)
            
            descriptionLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            descriptionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: countLabel, withOffset: 10)
            descriptionLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            descriptionLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            descHeightConstraint = descriptionLabel.autoSetDimension(.Height, toSize: 200)
            
            mapView.autoPinEdge(.Leading, toEdge: .Leading, ofView: imageView)
            mapView.autoPinEdge(.Top, toEdge: .Bottom, ofView: descriptionLabel, withOffset: 10)
            mapView.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            mapView.autoAlignAxisToSuperviewAxis(.Vertical)
            mapView.autoSetDimension(.Height, toSize: 200)
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if imageView.image == nil {
            imageHeightConstraint.constant = 250
        } else {
            imageHeightConstraint.constant = imageView.frame.width / imageView.image!.size.width * imageView.image!.size.height
        }
        
        descriptionLabel.sizeToFit()
        let descHeight = descriptionLabel.frame.height
        descHeightConstraint.constant = descHeight
        let viewHeight = 10 + imageHeightConstraint.constant + 10 + 18 + 5 + 18 + 10 + descHeight + 10 + 200 + 10
        scrollView.contentSize = CGSizeMake(view.bounds.width, viewHeight)
    }
    
    // actions
    
    func showMenu() {
        if let drawer = self.navigationController?.parentViewController as? DrawerViewController {
            drawer.showMenu()
        }
    }
    
    
    func showActions() {
        let copyButton = CNPPopupButton()
        copyButton.setTitle("Copy", forState: .Normal)
        copyButton.backgroundColor = Global.colorBg
        copyButton.setTitleColor(Global.colorSecond, forState: .Normal)
        copyButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        copyButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        copyButton.selectionHandler = {
            _ in
            self.popup?.dismissPopupControllerAnimated(true)
            let requestController = RequestViewController()
            requestController.request = .Copy
            requestController.inspection = self.inspection
            self.navigationController?.pushViewController(requestController, animated: true)
        }
        
        let editButton = CNPPopupButton()
        editButton.setTitle("Edit", forState: .Normal)
        editButton.backgroundColor = Global.colorBg
        editButton.setTitleColor(Global.colorSecond, forState: .Normal)
        editButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        editButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        editButton.selectionHandler = {
            _ in
            self.popup?.dismissPopupControllerAnimated(true)
            let requestController = RequestViewController()
            requestController.request = . Edit
            requestController.inspection = self.inspection
            self.navigationController?.pushViewController(requestController, animated: true)
        }
        
        let deleteButton = CNPPopupButton()
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.backgroundColor = Global.colorBg
        deleteButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        deleteButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        deleteButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        deleteButton.selectionHandler = {
            _ in
            self.popup?.dismissPopupControllerAnimated(true)
            
            let alert = UIAlertController(title: "Confirm",
                                          message: "Do you want to delete this request?",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
                _ in
                // TODO: remove request
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let theme = CNPPopupTheme.defaultTheme()
        theme.popupStyle = .ActionSheet
        theme.presentationStyle = .SlideInFromBottom
        
        let popup = CNPPopupController(contents: [copyButton, editButton, deleteButton])
        popup.theme = theme
        popup.presentPopupControllerAnimated(true)
        self.popup = popup
    }
    
    func loadData() {
        // image
        
        if let image = inspection.resultImage {
            if let url = NSURL(string: image) {
                imageView.imageURL = url
            }
        } else {
            imageView.image = nil
        }
        
        // location
        
        var hasLocation = false
        
        if let location = inspection.location  {
            if !location.isEmpty {
                let locs = location.characters.split{$0 == ","}.map(String.init)
                if let lat = Double(locs[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    ) {
                    if let lon = Double(locs[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        ) {
                        hasLocation = true
                        
                        mapView.hidden = false
                        
                        let point = MKPointAnnotation()
                        point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        mapView.addAnnotation(point)
                        
                        var mapRegion = MKCoordinateRegion()
                        mapRegion.center = point.coordinate
                        mapRegion.span.latitudeDelta = 0.002
                        mapRegion.span.longitudeDelta = 0.002
                        
                        mapView.setRegion(mapRegion, animated: true)
                    }
                }
            }
        }
        
        if !hasLocation {
            mapView.hidden = true
        }
        
        // others
        
        typeLabel.text = inspection.type
        countLabel.text = "\(inspection.count) Pipes"
        descriptionLabel.text = inspection.info
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        
        let timeFormmatter = NSDateFormatter()
        timeFormmatter.timeStyle = .ShortStyle
        timeFormmatter.dateStyle = .NoStyle
        
        dateLabel.text = dateFormatter.stringFromDate(inspection.startDate!)
        timeLabel.text = timeFormmatter.stringFromDate(inspection.startDate!)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
