//
//  SettingViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import SwiftOverlays
import DZNEmptyDataSet

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var constraintsAdded = false
    
    let minHeight : CGFloat = 10 + 100 + 20 + 1 + 20 + 50 + 150 + 20 + 1 + 20 + 60 + 20
    
    let scrollView = UIScrollView()
    
    let gradientView = GradientView()
    let backButton = UIButton()
    let countLabel = UILabel()
    
    let addButton = UIButton()
    let removeButton = UIButton()
    
    let separator1 = UIView()
    let orLabel1 = UILabel()
    
    let inspectionTitle = UILabel()
    let inspectionTable = UITableView()
    
    let separator2 = UIView()
    let orLabel2 = UILabel()
    
    let trainButton = UIButton()

    var inspections = [Inspection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Options"
        self.view.backgroundColor = UIColor.whiteColor()

        view.addSubview(gradientView)
        view.addSubview(scrollView)

        gradientView.addSubview(countLabel)
        gradientView.addSubview(backButton)
        
        scrollView.addSubview(addButton)
        scrollView.addSubview(removeButton)
        scrollView.addSubview(separator1)
        scrollView.addSubview(orLabel1)
        scrollView.addSubview(inspectionTitle)
        scrollView.addSubview(inspectionTable)
        scrollView.addSubview(separator2)
        scrollView.addSubview(orLabel2)
        scrollView.addSubview(trainButton)
 
        gradientView.userInteractionEnabled = true
        
        let backIcon = FAKIonIcons.iosArrowBackIconWithSize(30)
        backIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let backImg  = backIcon.imageWithSize(CGSizeMake(30, 30))
        backButton.setImage(backImg, forState: .Normal)
        backButton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        
        countLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        countLabel.textAlignment = .Center
        countLabel.textColor = UIColor.whiteColor()

        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if let home = controller as? HomeViewController {
                    countLabel.text = "TOTAL COUNT \(home.overlayView.getCount())"
                    break
                }
            }
        }
        
        
        addButton.setTitle("Add", forState: .Normal)
        addButton.setImage(UIImage(named: "add.png"), forState: .Normal)
        addButton.setTitleColor(Global.colorSelected, forState: .Normal)
        addButton.setTitleColor(Global.colorMain, forState: .Highlighted)
        addButton.imageView?.contentMode = .ScaleAspectFit
        addButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.titleLabel?.textAlignment = .Center
        addButton.addTarget(self, action: #selector(add), forControlEvents: .TouchUpInside)
        
        removeButton.setTitle("Remove", forState: .Normal)
        removeButton.setImage(UIImage(named: "subtract.png"), forState: .Normal)
        removeButton.setTitleColor(Global.colorSelected, forState: .Normal)
        removeButton.setTitleColor(Global.colorMain, forState: .Highlighted)
        removeButton.imageView?.contentMode = .ScaleAspectFit
        removeButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        removeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        removeButton.titleLabel?.textAlignment = .Center
        removeButton.addTarget(self, action: #selector(remove), forControlEvents: .TouchUpInside)
        
        
        separator1.backgroundColor = UIColor.lightGrayColor().alpha(0.3)
        separator2.backgroundColor = UIColor.lightGrayColor().alpha(0.3)
        
        orLabel1.text = "OR  "
        orLabel1.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        orLabel1.textColor = UIColor.lightGrayColor()
        orLabel1.backgroundColor = UIColor.whiteColor()
        orLabel1.textAlignment = .Center
        orLabel1.sizeToFit()
        
        orLabel2.text = "OR  "
        orLabel2.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        orLabel2.textColor = UIColor.lightGrayColor()
        orLabel2.backgroundColor = UIColor.whiteColor()
        orLabel2.textAlignment = .Center
        orLabel2.sizeToFit()

        
        trainButton.setTitle("SEND FOR TRAINING", forState: .Normal)
        trainButton.setTitleColor(Global.colorMain, forState: .Normal)
        trainButton.setTitleColor(Global.colorSelected, forState: .Highlighted)
        trainButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        trainButton.backgroundColor = Global.colorBg
        trainButton.addTarget(self, action: #selector(train), forControlEvents: .TouchUpInside)
        
        inspectionTitle.text = "ADD TO INSPECTION"
        inspectionTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        inspectionTitle.textColor = Global.colorMain
        inspectionTitle.backgroundColor = Global.colorBg
        inspectionTitle.textAlignment = .Center
        
        let titleSeparator = UIView()
        titleSeparator.backgroundColor = UIColor.lightGrayColor()
        inspectionTitle.addSubview(titleSeparator)
        
        inspectionTable.delegate = self
        inspectionTable.dataSource = self
        inspectionTable.backgroundColor = Global.colorBg
        inspectionTable.rowHeight = 60
        inspectionTable.tableFooterView = UIView()
        inspectionTable.emptyDataSetSource = self
        inspectionTable.emptyDataSetDelegate = self

        self.view.setNeedsUpdateConstraints()
        
        refresh()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let margin : CGFloat = 10
            
            gradientView.autoPinEdgeToSuperviewEdge(.Left)
            gradientView.autoPinEdgeToSuperviewEdge(.Right)
            gradientView.autoPinEdgeToSuperviewEdge(.Top)
            gradientView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)
            gradientView.autoSetDimension(.Height, toSize: 50)
            
            countLabel.autoPinEdgesToSuperviewEdges()
            
            backButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
            backButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
            backButton.autoSetDimensionsToSize(CGSizeMake(50, 50))
            
            scrollView.autoPinEdgeToSuperviewEdge(.Left)
            scrollView.autoPinEdgeToSuperviewEdge(.Right)
            scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
            scrollView.autoPinEdge(.Top, toEdge: .Bottom, ofView: gradientView)
            
            
            addButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            addButton.autoSetDimensionsToSize(CGSizeMake(100, 100))
            addButton.autoAlignAxis(.Vertical, toSameAxisOfView: scrollView, withMultiplier: 0.5)
            
            addButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Bottom)
            addButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Left)
            addButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Right)
            addButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 80)
            addButton.titleLabel?.autoSetDimensionsToSize(CGSizeMake(100, 20))
            
            addButton.imageView?.autoPinEdgeToSuperviewEdge(.Top)
            addButton.imageView?.autoPinEdgeToSuperviewEdge(.Right)
            addButton.imageView?.autoPinEdgeToSuperviewEdge(.Left)
            addButton.imageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
            addButton.imageView?.autoSetDimension(.Width, toSize: 80)
            addButton.imageView?.autoSetDimension(.Height, toSize: 80)
            
            
            removeButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            removeButton.autoSetDimensionsToSize(CGSizeMake(100, 100))
            removeButton.autoAlignAxis(.Vertical, toSameAxisOfView: scrollView, withMultiplier: 1.5)
            
            removeButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Bottom)
            removeButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Left)
            removeButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Right)
            removeButton.titleLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 80)
            removeButton.titleLabel?.autoSetDimensionsToSize(CGSizeMake(100, 20))
            
            removeButton.imageView?.autoPinEdgeToSuperviewEdge(.Top)
            removeButton.imageView?.autoPinEdgeToSuperviewEdge(.Right)
            removeButton.imageView?.autoPinEdgeToSuperviewEdge(.Left)
            removeButton.imageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
            removeButton.imageView?.autoSetDimension(.Width, toSize: 80)
            removeButton.imageView?.autoSetDimension(.Height, toSize: 80)
            
            separator1.autoSetDimension(.Height, toSize: 1)
            separator1.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            separator1.autoAlignAxisToSuperviewAxis(.Vertical)
            separator1.autoPinEdge(.Top, toEdge: .Bottom, ofView: addButton, withOffset: 20)

            orLabel1.autoAlignAxisToSuperviewAxis(.Vertical)
            orLabel1.autoAlignAxis(.Horizontal, toSameAxisOfView: separator1)
            
            inspectionTitle.autoSetDimension(.Height, toSize: 50)
            inspectionTitle.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            inspectionTitle.autoAlignAxisToSuperviewAxis(.Vertical)
            inspectionTitle.autoPinEdge(.Top, toEdge: .Bottom, ofView: separator1, withOffset: 20)

            inspectionTitle.subviews.last?.autoSetDimension(.Height, toSize: 1)
            inspectionTitle.subviews.last?.autoMatchDimension(.Width, toDimension: .Width, ofView: inspectionTitle, withOffset: -2 * margin)
            inspectionTitle.subviews.last?.autoAlignAxisToSuperviewAxis(.Vertical)
            inspectionTitle.subviews.last?.autoPinEdgeToSuperviewEdge(.Bottom)
            
            
            inspectionTable.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            inspectionTable.autoAlignAxisToSuperviewAxis(.Vertical)
            inspectionTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: inspectionTitle, withOffset: 0)
            inspectionTable.autoSetDimension(.Height, toSize: 150, relation: .GreaterThanOrEqual)
            inspectionTable.autoMatchDimension(.Height, toDimension: .Height, ofView: scrollView, withOffset: -minHeight + 150, relation: .GreaterThanOrEqual)
            
            separator2.autoSetDimension(.Height, toSize: 1)
            separator2.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -2 * margin)
            separator2.autoAlignAxisToSuperviewAxis(.Vertical)
            separator2.autoPinEdge(.Top, toEdge: .Bottom, ofView: inspectionTable, withOffset: 20)
            
            orLabel2.autoAlignAxisToSuperviewAxis(.Vertical)
            orLabel2.autoAlignAxis(.Horizontal, toSameAxisOfView: separator2)

            trainButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: separator2, withOffset: 20)
            trainButton.autoSetDimension(.Height, toSize: 60)
            trainButton.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView, withOffset: -20)
            trainButton.autoAlignAxisToSuperviewAxis(.Vertical)
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = max(view.bounds.size.height - 50, minHeight)
        scrollView.contentSize = CGSizeMake(view.bounds.size.width, height)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    // actions
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func add() {
        if let home = self.navigationController?.viewControllers.first as? HomeViewController  {
            home.overlayView.type = PipeType.Added
        }
        back()
    }
    
    func remove() {
        if let home = self.navigationController?.viewControllers.first as? HomeViewController  {
            home.overlayView.type = PipeType.Removed
        }
        back()
    }
    
    func train() {
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if let home = controller as? HomeViewController {
                    let train = TrainingViewController()
                    train.image = home.resultImage
                    self.navigationController?.pushViewController(train, animated: true)
                    break
                }
            }
        }
    }
    
    func inspect() {
        
    }
    
    // table view
    
    func refresh() {
        var endPoint : String!
        var param : String!
        
        if Global.user.userType == User.typeManager {
            endPoint = "get_manager_new_jobs"
            param = "manager_name"
        } else {
            endPoint = "get_inspector_new_jobs"
            param = "inspector_name"
        }
        
        Global.client.GET(endPoint,
                          parameters: [
                            param: Global.user.email!
                            ] as NSDictionary,
                          progress:nil,
                          success: {
                            (task, response) in
                            print(response)
                            
                            if let response = response as? [[String : AnyObject]] {
                                self.inspections.removeAll()
                                for dict in response {
                                    self.inspections.append(Inspection(dict: dict))
                                }
                            }
                            
                            self.inspectionTable.reloadData()
            }, failure: {
                (task, error) in
                let alert = UIAlertController(title: "Error",
                    message: "Can't fetch data. Please try again!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var inspectionCell : InspectionTableViewCell!
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? InspectionTableViewCell {
            inspectionCell = cell
        } else {
            inspectionCell = InspectionTableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        inspectionCell.minimize = true
        inspectionCell.inspection = inspections[indexPath.row]
        return inspectionCell
    }
    
    // empty view
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "inspections.png")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No inspection entry"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let text = "Refresh"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline),
                     NSForegroundColorAttributeName: Global.colorMain]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        refresh()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SwiftOverlays.showBlockingWaitOverlay()
        
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if let home = controller as? HomeViewController {
                    let id = inspections[indexPath.row].id!
                    let overlayView = home.overlayView
                    
                    var image = home.resultImage!
                    var imageData : NSData!
                    
                    //Compress the image
                    var compression : CGFloat = 1
                    let maxCompression : CGFloat = 0.1
                    
                    if let overlay = overlayView.overlayImage {
                        image = image.merge(overlay, alpha: overlayView.alpha)
                    }
                    
                    imageData = UIImageJPEGRepresentation(image, compression)!
                    while (imageData.length > 2 * 1024 * 1024 && compression > maxCompression) {
                        print("Compress to \(compression)")
                        compression -= 0.005
                        imageData = UIImageJPEGRepresentation(image, compression);
                    }
                    
                    var loc = ""
                    if let location = Global.instance.location {
                        loc = "\(location.latitude),\(location.longitude)"
                    }
                    Global.client.POST("update_inspection_results",
                                       parameters: [
                                        "request_id": id,
                                        "status": "completed",
                                        "location": loc,
                                        "count": home.overlayView.getCount(),
                                        "processed_image_file_name": "inspection_result.jpg",
                                        "processed_image_file_data": imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                                        ] as NSDictionary,
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
                            let alert = UIAlertController(title: "Error",
                                message: "Cannot upload image: \(error.localizedDescription)",
                                preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                    })
                    
                    break
                }
            }
        }
    }
}
