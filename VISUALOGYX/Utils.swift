//
//  Utils.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/13/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

func postImage(url: NSURL, image: UIImage, imageName: String, params: [String : String], completion: ((String?) -> Void)) {
    let request = NSMutableURLRequest(URL: url)
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    
    request.cachePolicy = .ReloadIgnoringLocalCacheData
    request.HTTPShouldHandleCookies = false
    request.timeoutInterval = 120
    request.HTTPMethod = "POST"
    
    let boundary = "unique-consistent-string"
    
    // set Content-Type in HTTP header
    let contentType = "multipart/form-data; boundary=\(boundary)"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    // post body
    let body = NSMutableData()
    
    // add params (all params are strings)
    for param in params {
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\(param.0)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(param.1)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    // add image data
    body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    body.appendData("Content-Disposition: form-data; name=\(imageName); filename=imageName.jpg\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    body.appendData(imageData!)
    body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    
    body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    
    // setting the body of the post to the reqeust
    request.HTTPBody = body
    
    // set the content-length
    request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!, completionHandler: {
        (response, data, error) in
        
        if(error != nil) {
            completion(error!.description)
            return
        }
        
        let s = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print("Response: \(s)")
        completion(nil)
        
    })
}