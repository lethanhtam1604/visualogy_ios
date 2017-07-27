//
//  InspectionTableViewCell.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/4/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import MapKit
import FontAwesomeKit

class InspectionTableViewCell : UITableViewCell, MKMapViewDelegate {
    let containerView = UIView()
    let iconInspection = UIImageView(image: UIImage(named: "assignment.png"))
    let previewView = AsyncImageView(frame: CGRectZero)
    let iconLocation = UIImageView(image: UIImage(named: "location.png"))
    let mapView = MKMapView()
    let unknowLabel = UILabel()
    let shareButton = UIButton()
    let changeButton = UIButton()
    let typeLabel = UILabel()
    let siteLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let point = MKPointAnnotation()
    
    static var cacheLocations = [String : String]()
    
    var constraintsAdded = false
    
    var minimize = false {
        didSet {
            iconInspection.hidden = !minimize
            previewView.hidden = minimize
            iconLocation.hidden = minimize
            mapView.hidden = minimize
            unknowLabel.hidden = minimize
            shareButton.hidden = minimize
            changeButton.hidden = minimize
            descriptionLabel.hidden = minimize
        }
    }
    
    var managerMode = false {
        didSet {
            shareButton.hidden = managerMode
            changeButton.hidden = !managerMode
        }
    }
    
    var inspection : Inspection! {
        didSet {
            
            // image
            
            if !minimize {
                let preview = managerMode ? inspection.preview : inspection.resultPreview
                if let image = preview {
                    if let url = NSURL(string: image) {
                        previewView.imageURL = url
                    }
                } else {
                    previewView.image = nil
                }
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
                            let loc = CLLocation(latitude: lat, longitude: lon)
                            
                            hasLocation = true
                            
                            if !minimize {
                                unknowLabel.hidden = true
                                mapView.hidden = false
                                
                                point.coordinate = CLLocationCoordinate2DMake(lat, lon)
                                
                                var mapRegion = MKCoordinateRegion()
                                mapRegion.center = point.coordinate
                                mapRegion.span.latitudeDelta = 0.001
                                mapRegion.span.longitudeDelta = 0.001
                                
                                mapView.setRegion(mapRegion, animated: true)
                            }
                            
                            if let cache = InspectionTableViewCell.self.cacheLocations[location] {
                                self.siteLabel.text = cache
                            } else {
                                self.siteLabel.text = "Searching..."
                                let geoCoder = CLGeocoder()
                                geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
                                    if let placeMark = placemarks?[0] {
                                        self.siteLabel.text = "Unknown"
                                        if let address = placeMark.addressDictionary {
                                            if let locationName = address["Name"] as? String {
                                                self.siteLabel.text = locationName
                                            }
                                        }
                                        InspectionTableViewCell.self.cacheLocations[location] = self.siteLabel.text!
                                    }
                                })
                            }
                            
                        }
                    }
                }
            }
            
            if !hasLocation && !minimize {
                unknowLabel.hidden = false
                mapView.hidden = true
            }
            
            // others
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.dateStyle = .ShortStyle
            
            let timeFormmatter = NSDateFormatter()
            timeFormmatter.timeStyle = .ShortStyle
            timeFormmatter.dateStyle = .NoStyle
            
            

            typeLabel.text = inspection.type
            descriptionLabel.text = inspection.info
            
            dateLabel.text = dateFormatter.stringFromDate(inspection.startDate!)
            timeLabel.text = timeFormmatter.stringFromDate(inspection.startDate!)
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
        addSubview(containerView)
        
        containerView.addSubview(iconInspection)
        containerView.addSubview(previewView)
        containerView.addSubview(iconLocation)
        containerView.addSubview(mapView)
        containerView.addSubview(unknowLabel)
        containerView.addSubview(shareButton)
        containerView.addSubview(changeButton)
        containerView.addSubview(typeLabel)
        containerView.addSubview(siteLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(descriptionLabel)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        previewView.contentMode = .ScaleAspectFill
        previewView.backgroundColor = Global.colorBg
        previewView.clipsToBounds = true
        previewView.layer.cornerRadius = 3
        
        iconLocation.contentMode = .ScaleAspectFit
        
        iconInspection.contentMode = .ScaleAspectFit

        mapView.backgroundColor = Global.colorBg
        mapView.userInteractionEnabled = false
        mapView.hidden = true
        mapView.subviews[1].removeFromSuperview()
        mapView.delegate = self

        shareButton.setImage(UIImage(named: "share.png"), forState: .Normal)
        shareButton.imageView?.contentMode = .ScaleAspectFit

        
        let changeIcon = FAKFontAwesome.angleDownIconWithSize(30)
        changeIcon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
        changeButton.setImage(changeIcon.imageWithSize(CGSizeMake(30, 30)), forState: .Normal)
        changeButton.imageView?.contentMode = .ScaleAspectFit
        changeButton.contentEdgeInsets = UIEdgeInsetsZero
        
        unknowLabel.text = "Unspecific"
        unknowLabel.font = UIFont.systemFontOfSize(12)
        unknowLabel.adjustsFontSizeToFitWidth = true
        unknowLabel.numberOfLines = 1
        unknowLabel.textColor = UIColor.darkGrayColor()
        
        typeLabel.font = UIFont.boldSystemFontOfSize(14)
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.numberOfLines = 1
        typeLabel.textColor = UIColor.darkGrayColor()

        siteLabel.font = UIFont.systemFontOfSize(11)
        siteLabel.adjustsFontSizeToFitWidth = true
        siteLabel.numberOfLines = 1
        siteLabel.textColor = UIColor.darkGrayColor()
        
        dateLabel.font = UIFont.systemFontOfSize(11)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.numberOfLines = 1
        dateLabel.textColor = UIColor.darkGrayColor()
        
        timeLabel.font = UIFont.systemFontOfSize(11)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.numberOfLines = 1
        timeLabel.textAlignment = .Right
        timeLabel.textColor = UIColor.darkGrayColor()
        
        descriptionLabel.font = UIFont.systemFontOfSize(10)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.textAlignment = .Justified
        descriptionLabel.textColor = UIColor.darkGrayColor()
        
        mapView.addAnnotation(point)
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            containerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 3)
            containerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 3)
            containerView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            containerView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)

            if minimize {
                iconInspection.autoPinEdgeToSuperviewEdge(.Left)
                iconInspection.autoPinEdgeToSuperviewEdge(.Top)
                iconInspection.autoSetDimension(.Height, toSize: 30)
                iconInspection.autoMatchDimension(.Width, toDimension: .Height, ofView: iconInspection)

                typeLabel.autoPinEdge(.Left, toEdge: .Right, ofView: iconInspection, withOffset: 10)
                typeLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 1)
                typeLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -40)
                typeLabel.autoSetDimension(.Height, toSize: 17)
                
                siteLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: typeLabel)
                siteLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: typeLabel)
                siteLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -40)
                siteLabel.autoSetDimension(.Height, toSize: 15)
                
                dateLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: typeLabel)
                dateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: siteLabel)
                dateLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -40)
                dateLabel.autoSetDimension(.Height, toSize: 15)
                
                timeLabel.autoPinEdgeToSuperviewEdge(.Right)
                timeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: siteLabel)
                timeLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -40)
                timeLabel.autoSetDimension(.Height, toSize: 15)
                
            } else {
                previewView.autoPinEdgeToSuperviewEdge(.Left)
                previewView.autoPinEdgeToSuperviewEdge(.Top)
                previewView.autoMatchDimension(.Height, toDimension: .Height, ofView: containerView)
                previewView.autoMatchDimension(.Width, toDimension: .Height, ofView: previewView)
                
                iconLocation.autoPinEdge(.Left, toEdge: .Right, ofView: previewView, withOffset: 5)
                iconLocation.autoPinEdgeToSuperviewEdge(.Top, withInset: 20)
                iconLocation.autoSetDimensionsToSize(CGSizeMake(20, 20))
                
                shareButton.autoSetDimensionsToSize(CGSizeMake(30, 30))
                shareButton.autoPinEdgeToSuperviewEdge(.Top)
                shareButton.autoPinEdgeToSuperviewEdge(.Right)
                
                changeButton.autoSetDimensionsToSize(CGSizeMake(30, 30))
                changeButton.autoPinEdgeToSuperviewEdge(.Top)
                changeButton.autoPinEdgeToSuperviewEdge(.Right)
                
                mapView.autoPinEdgeToSuperviewEdge(.Top)
                mapView.autoPinEdge(.Left, toEdge: .Right, ofView: iconLocation, withOffset: 5)
                mapView.autoSetDimension(.Height, toSize: 40)
                mapView.autoSetDimension(.Width, toSize: 60)
                
                unknowLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 20)
                unknowLabel.autoPinEdge(.Left, toEdge: .Right, ofView: iconLocation, withOffset: 5)
                unknowLabel.autoSetDimension(.Height, toSize: 20)
                unknowLabel.autoSetDimension(.Width, toSize: 60)
                
                typeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: iconLocation)
                typeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: iconLocation, withOffset: 2)
                typeLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -150)
                typeLabel.autoSetDimension(.Height, toSize: 15)
                
                siteLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: iconLocation)
                siteLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: typeLabel)
                siteLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -150)
                siteLabel.autoSetDimension(.Height, toSize: 15)
                
                dateLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: iconLocation)
                dateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: siteLabel)
                dateLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -150)
                dateLabel.autoSetDimension(.Height, toSize: 15)
                
                timeLabel.autoPinEdgeToSuperviewEdge(.Right)
                timeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: siteLabel)
                timeLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView, withOffset: -150)
                timeLabel.autoSetDimension(.Height, toSize: 15)
                
                descriptionLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: iconLocation)
                descriptionLabel.autoPinEdgeToSuperviewEdge(.Right)
                descriptionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: dateLabel)
                descriptionLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            }
        }
        super.updateConstraints()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let icon = FAKFontAwesome.mapMarkerIconWithSize(15)
        icon.addAttribute(NSForegroundColorAttributeName, value: Global.colorSelected)
        annotationView?.image = icon.imageWithSize(CGSizeMake(15, 15))
        
        return annotationView
    }
}