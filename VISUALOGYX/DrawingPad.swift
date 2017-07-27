//
//  DrawingPad.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/7/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class DrawingPad: UIImageView {

    var backgroundImage : UIImage?
    var overlayImage : UIImage?
    var color : UIColor?
    var type : PipeType?
    
    var pipes = [Pipe]()
    var pendingPipe : Pipe?
    var pendingRadius : CGFloat = 0
    var pendingDrag = false
    var pendingCenter : CGPoint = CGPointZero

    
    init() {
        super.init(frame: CGRectZero)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        clipsToBounds = true
        userInteractionEnabled = true
        contentMode = .ScaleAspectFit
        //alpha = 0.5
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(overlayTapped))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action:#selector(overlayPinched))
        let panGestureRecognizer = UIPanGestureRecognizer(target:self, action:#selector(overlayPaned))
        
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        
        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(pinchGestureRecognizer)
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func overlayPaned(touch: UIPanGestureRecognizer) {
        if type != nil && type != PipeType.Removed {
            if let pendingPipe = pendingPipe {
                switch touch.state {
                case .Began:
                    pendingDrag = pendingPipe.frame.contains(getImagePoint(touch))
                    pendingCenter = pendingPipe.center
                    
                case .Changed:
                    if pendingDrag {
                        let translation = touch.translationInView(self)
                        let newCenter = CGPointMake(pendingCenter.x + translation.x, pendingCenter.y + translation.y)
                        pendingPipe.center = newCenter
                    }
                default:
                    break
                }
            }
        }
        
        drawOverlay()
    }
    
    func overlayTapped(touch: UIGestureRecognizer) {
        if backgroundImage == nil {
            return
        }
        
        let imagePoint = getImagePoint(touch)
        
        if type != nil && type != PipeType.Removed {
            pendingPipe = Pipe()
            pendingPipe?.type = type!
            pendingPipe?.radius = 40 * self.backgroundImage!.size.width / self.frame.size.width
            
            var max = 0
            for p in pipes {
                if p.id > max {
                    max = p.id
                }
            }
            
            pendingPipe?.id = max + 1
            
            pipes.append(pendingPipe!)
             pendingPipe?.center = imagePoint
        }
        
        if type == PipeType.Removed {
            for pipeIndex in (0..<pipes.count).reverse() {
                let pipe = pipes[pipeIndex]
                if pipe.frame.contains(imagePoint) {
                    
                    switch pipe.type {
                    case .Detected:
                        pipe.type = .Removed
                        reorder(pipe.id)
                        pipe.id = -1
                    case .Added:
                        reorder(pipes[pipeIndex].id)
                        pipes.removeAtIndex(pipeIndex)
                    default:
                        break
                    }
                    
                    break
                }
            }
        }
        
        drawOverlay()
    }
    
    func reorder(number: Int) {
        for p in pipes {
            if(p.id > number) {
                p.id -= 1
            }
        }
    }
    
    func overlayPinched(touch: UIPinchGestureRecognizer) {
        if backgroundImage == nil {
            return
        }
        
        if type != nil && type != PipeType.Removed {
            if let pendingPipe = pendingPipe {
                switch touch.state {
                case .Began:
                    pendingRadius = pendingPipe.radius
                case .Changed:
                    pendingPipe.radius = pendingRadius * touch.scale
                default:
                    break
                }
            }
        }
        
        drawOverlay()
    }
    
    func drawOverlay() {
        if backgroundImage == nil {
            return
        }
        
        self.tintColor = color
        if let origin = backgroundImage {
            let textColor = UIColor.whiteColor()
            let textFont = UIFont(name: "Helvetica Bold", size: 14)!
            let textFontAttributes = [
                NSFontAttributeName: textFont,
                NSForegroundColorAttributeName: textColor,
                ]
            
            UIGraphicsBeginImageContextWithOptions(origin.size, false, origin.scale)
            
            for pipe in pipes {
                if color != nil {
                    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext()!, color!.CGColor)
                    pipe.type.image.imageWithRenderingMode(.AlwaysTemplate).drawInRect(pipe.frame, blendMode: CGBlendMode.Normal, alpha: 0.6)
                } else {
                    pipe.type.image.drawInRect(pipe.frame, blendMode: .Normal, alpha: 0.6)
                }

                if pipe.type != .Removed {
                    let drawText : NSString = "\(pipe.id)"
                    let rect = CGRectMake(pipe.x, pipe.y, 50, 50)
                    drawText.drawInRect(rect, withAttributes: textFontAttributes)
                }
            }
            
            overlayImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.image = overlayImage
        }
    }
    
    func getImagePoint(touch: UIGestureRecognizer) -> CGPoint {
        let viewPoint = touch.locationInView(self)
        return convertPoint(viewPoint)
    }
    
    func convertPoint(viewPoint: CGPoint) -> CGPoint {
        let viewSize = frame.size
        let imageSize = backgroundImage!.size
        let scaleX = imageSize.width / viewSize.width
        let scaleY = imageSize.height / viewSize.height
        let scale = contentMode == .ScaleAspectFit ? max(scaleX, scaleY) : min(scaleX, scaleY)
        let deltaX = (viewSize.width * scale - imageSize.width) / 2
        let deltaY = (viewSize.height * scale - imageSize.height) / 2
        let realX = viewPoint.x * scale - deltaX
        let realY = viewPoint.y * scale - deltaY
        let imagePoint = CGPointMake(realX, realY)
        
        return imagePoint
    }
    
    func convertDimensionToImage(length: CGFloat) -> CGFloat {
        let viewSize = frame.size
        let imageSize = backgroundImage!.size
        let scaleX = imageSize.width / viewSize.width
        let scaleY = imageSize.height / viewSize.height
        let scale = contentMode == .ScaleAspectFit ? max(scaleX, scaleY) : min(scaleX, scaleY)
        
        return ceil(length * scale)
    }

    func convertDimensionToView(length: CGFloat) -> CGFloat {
        let viewSize = frame.size
        let imageSize = backgroundImage!.size
        let scaleX = imageSize.width / viewSize.width
        let scaleY = imageSize.height / viewSize.height
        let scale = contentMode == .ScaleAspectFit ? max(scaleX, scaleY) : min(scaleX, scaleY)
        
        return ceil(length / scale)
    }
    
    func getCount() -> Int {
        var count = 0
        for pipe in pipes {
            if pipe.type != .Removed {
                count += 1
            }
        }
        return count
    }
}
