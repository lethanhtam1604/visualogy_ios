//
//  DrawerViewController.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController, MenuViewDelegate {
    private var constraintsAdded = false
    private var visiableController : UIViewController?
    private let menuView = MenuView()
    
    // UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(menuView)
        menuView.delegate = self
        menuItemDidChange()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.All]
    }
    
    // actions
    
    func showMenu() {
        menuView.show()
    }
    
    func select(item: MenuItem) {
        menuView.selectedItem = item
    }
    
    // menu events
    
    func menuItemDidChange() {
        visiableController?.view.hidden = true
        visiableController = nil
        
        for vc in self.childViewControllers {
            vc.willMoveToParentViewController(nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
        
        if visiableController == nil {
            var childToAdd : UIViewController!
            
            switch menuView.selectedItem {
            case .Home:
                childToAdd = HomeViewController()
            
            case .Inspections:
                let inspection = InspectionViewController()
                inspection.managerMode = true
                childToAdd = inspection
            
            case .Training:
                childToAdd = TrainingViewController()
                
            case .History:
                let inspection = InspectionViewController()
                inspection.managerMode = false
                childToAdd = inspection
            
            case .About:
                childToAdd = AboutViewController()
                
            case .Logout:
                let settings = NSUserDefaults()
                settings.removeObjectForKey("email")
                settings.removeObjectForKey("password")
                settings.synchronize()
                
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
                UIApplication.sharedApplication().keyWindow!.replaceRootViewControllerWith(UINavigationController(rootViewController: SignInViewController()), animated: true, completion: nil)
                return
                
            default:
                break
            }
            
            childToAdd = UINavigationController(rootViewController: childToAdd)
            childToAdd.view.tag = menuView.selectedItem.hashValue
            addChildViewController(childToAdd)
            view.addSubview(childToAdd.view)
            childToAdd.didMoveToParentViewController(self)
            
            visiableController = childToAdd
        }
        
        view.bringSubviewToFront(visiableController!.view)
        view.bringSubviewToFront(menuView)
        
        menuView.hide()
    }
    
    func menuWillShow() {
        
    }
    
    func menuDidShow() {
        
    }
    
    func menuWillHide() {
    }
    
    func menuDidHide() {
        if let visiableController = visiableController {
            switch menuView.selectedItem {
            case .Home:
                // restore camera status
                
                let nav = visiableController as! UINavigationController
                if let home = nav.visibleViewController as? HomeViewController {
                    if home.shouldReopenCamera {
                        home.shouldReopenCamera = false
                        home.shouldShowCamera = true
                        home.showCamera()
                    }
                }
            default:
                break
            }
        }
    }
}