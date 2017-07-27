//
//  Inspection.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/5/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class Inspection {
    var id : String?
    var preview : String?
    var image : String?
    var location : String?
    var type : String?
    var startDate : NSDate?
    var endDate : NSDate?
    var info : String?
    var count : Int = 0
    var inspector : String?
    var resultPreview : String?
    var resultImage : String?
    
    init() {
    }
    
    init(dict: [String : AnyObject]) {
        id = dict["request_id"] as? String
        preview = dict["image_thumb_data"] as? String
        image = dict["image_data"] as? String
        resultPreview = dict["proc_image_thumb_data"] as? String
        resultImage = dict["proc_image_data"] as? String
        type = dict["name"] as? String
        if let c = dict["count"] as? Int {
            count = c
        }
        location = dict["location"] as? String
        info = dict["description"] as? String
        startDate = (dict["start_date"] as! String).dateFromISO8601
        endDate = (dict["end_date"] as! String).dateFromISO8601
        inspector = dict["inspector_name"] as? String
    }
    
    init(preview: String?, location: String?, type: String?, startDate: NSDate?, endDate: NSDate?, info: String?) {
        self.preview = preview
        self.location = location
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.info = info
    }
}