//
//  InspectionViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import DZNEmptyDataSet
import SwiftOverlays

class InspectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    let tableView = UITableView()
    
    var constraintsAdded = false
    var inspections = [Inspection]()
    var managerMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        
        self.title = managerMode ? "Manager Mode" : "History"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        let menuIcon = FAKIonIcons.androidMenuIconWithSize(30)
        menuIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let menuImg  = menuIcon.imageWithSize(CGSizeMake(30, 30))
        let menuButton = UIBarButtonItem(image: menuImg, style: .Plain, target: self, action: #selector(showMenu))
        self.navigationItem.leftBarButtonItem = menuButton
        
        if managerMode {
            let addIcon = FAKIonIcons.plusIconWithSize(30)
            addIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            let addImg  = addIcon.imageWithSize(CGSizeMake(30, 30))
            let addButton = UIBarButtonItem(image: addImg, style: .Plain, target: self, action: #selector(add))
            self.navigationItem.rightBarButtonItem = addButton
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        view.addSubview(tableView)
        
        self.view.setNeedsUpdateConstraints()
        
        // fetch data
        refresh()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            tableView.autoPinEdgesToSuperviewEdges()
        }
        super.updateViewConstraints()
    }
    
    
    
    // table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfCell = inspections.count
        if numOfCell > 0 {
            return numOfCell * 2 - 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row % 2 == 0 ? 150 : 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            var inspectionCell : InspectionTableViewCell!
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? InspectionTableViewCell {
                inspectionCell = cell
            } else {
                inspectionCell = InspectionTableViewCell(style: .Default, reuseIdentifier: "cell")
                inspectionCell.managerMode = managerMode
                inspectionCell.shareButton.addTarget(self, action: #selector(share), forControlEvents: .TouchUpInside)
                inspectionCell.changeButton.addTarget(self, action: #selector(change), forControlEvents: .TouchUpInside)
                
            }
            
            inspectionCell.shareButton.tag = indexPath.row
            
            inspectionCell.changeButton.tag = indexPath.row

            inspectionCell.inspection = inspections[indexPath.row / 2]
            
            return inspectionCell
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("separator") {
            return cell
        } else {
            return InspectionSeparator(style: .Default, reuseIdentifier: "separator")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (managerMode) {
            return
        }
        
        let detail = DetailViewController()
        detail.inspection = inspections[indexPath.row / 2]
        detail.managerMode = managerMode
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
    // empty view
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: managerMode ? "inspections.png" : "history.png")
    }
    
    func titleForEmptyDataSet(scrobllView: UIScrollView!) -> NSAttributedString! {
        let text = managerMode ? "No inspection entry" :  "No inspection inspection entry"
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
    
    
    // scrolling
    
    //    func scrollViewDidScroll(scrollView : UIScrollView) {
    //        let actualPosition = scrollView.contentOffset.y
    //        let contentHeight = scrollView.contentSize.height - tableView.frame.size.height + 10
    //
    //        if (actualPosition >= contentHeight) {
    //            refresh()
    //        }
    //    }
    
    
    // actions
    
    func showMenu() {
        if let drawer = self.navigationController?.parentViewController as? DrawerViewController {
            drawer.showMenu()
        }
    }
    
    func refresh() {
        SwiftOverlays.showBlockingWaitOverlay()
        
        var endPoint : String!
        var param : String!
        
        if Global.user.userType == User.typeManager {
            endPoint = managerMode ? "get_manager_new_jobs" : "get_manager_history"
            param = "manager_name"
        } else {
            endPoint = managerMode ? "get_inspector_new_jobs" : "get_inspector_history"
            param = "inspector_name"
        }
        
        Global.client.GET(endPoint,
                          parameters: [
                            param: Global.user.email!] as NSDictionary,
                          progress:nil,
                          success: {
                            (task, response) in
                            SwiftOverlays.removeAllBlockingOverlays()
                            print(response)
                            
                            if let response = response as? [[String : AnyObject]] {
                                self.inspections.removeAll()
                                for dict in response {
                                    self.inspections.append(Inspection(dict: dict))
                                }
                            }
                            
                            self.tableView.reloadData()
            }, failure: {
                (task, error) in
                SwiftOverlays.removeAllBlockingOverlays()

                let alert = UIAlertController(title: "Error",
                    message: "Can't fetch data. Please try again!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
    func share(sender: UIButton) {
        let inspection = inspections[sender.tag / 2]
        
        let share = ShareViewController()
        share.inspection = inspection
        share.anchorView = sender
        
        addChildViewController(share)
        view.addSubview(share.view)
        share.didMoveToParentViewController(self)
        
        share.view.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            share.view.alpha = 1
        })
    }
    
    func change(sender: UIButton) {
        let inspection = inspections[sender.tag / 2]
        
        let change = ChangeViewController()
        change.inspection = inspection
        change.anchorView = sender
        
        addChildViewController(change)
        view.addSubview(change.view)
        change.didMoveToParentViewController(self)
        
        change.view.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            change.view.alpha = 1
        })
    }
    
    func add() {
        let requestController = RequestViewController()
        requestController.request = .Add
        requestController.inspection = nil
        self.navigationController?.pushViewController(requestController, animated: true)
    }
}
