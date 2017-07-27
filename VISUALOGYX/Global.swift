//
//  Global.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/2/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation

class Global: NSObject, UIAlertViewDelegate, CLLocationManagerDelegate {
    static let instance = Global()
    
    // colors
    
    static let colorMain = UIColor(0x1AA79B)
    static let colorSecond = UIColor(0x33B476)
    static let colorSelected = UIColor(0x434F5D)
    static let colorBg = UIColor(0xE6E7E8)
    static let colorStatus = UIColor(0x333333)
    static let colorFacebook = UIColor(0x3C5A98)
    static let colorGoogle = UIColor(0xDD4D3E)

    // maximum image size
    
    static let imageSize = CGSizeMake(1024, 768)
    
    // global variables
    
    static var user : User!
    
    // API endpoint base URL

    static let baseURL = "http://139.59.27.136/vlapi/"
    
    static var client : AFHTTPSessionManager {
        let sharedClient = AFHTTPSessionManager(baseURL: NSURL(string: baseURL))
        sharedClient.requestSerializer = AFJSONRequestSerializer()
        return sharedClient
    }
    
    // location
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var requesting = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(appWillEnterForeground),
                                                         name: UIApplicationWillEnterForegroundNotification,
                                                         object: nil)
    }
    
    func appWillEnterForeground() {
        if requesting {
            requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate {
            self.location = locValue
        }
    }
    
    func requestLocation() {
        requesting = true
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .Restricted, .Denied:
            UIAlertView(title: "Location Access Disabled",
                        message: "In order to work properly, please open this app's settings and enable location access.", delegate: self,
                        cancelButtonTitle: "Cancel",
                        otherButtonTitles: "Settings").show()
            
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            locationManager.startUpdatingLocation()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            self.requestLocation()
        default:
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}
