//
//  Stone.swift
//  SuperFour2
//
//  Created by AceLan Kao on 2014/6/10.
//  Copyright (c) 2014年 AceLan Kao. All rights reserved.
//

import UIKit

class Stone : UIView {
    var color: UIColor
    var radius: UInt
    let CHEESE_RADIUS: CGFloat = 25
    
    init(frame f: CGRect, color c: UIColor) {
        color = c
        // TODO: should use display resolution to calc the radius
        radius = 25
        super.init(frame: f)
        opaque = false
        userInteractionEnabled = true
    }
    
    func drawCheese(context: CGContextRef) {
        CGContextSetLineWidth(context, 5.0)
        color.setStroke()
        
        // draw a circle
        CGContextBeginPath(context);
        CGContextAddArc(context, CGFloat(3+radius), CGFloat(3+radius), CGFloat(radius), CGFloat(0), CGFloat(2*M_PI), 1);
        CGContextStrokePath(context);
        
        var points: CGPoint[] = [
            CGPointMake(0, CGFloat(arc4random() % 60)),
            CGPointMake(60, CGFloat(arc4random() % 60)),
            CGPointMake(0, CGFloat(arc4random() % 60)),
            CGPointMake(60, CGFloat(arc4random() % 60)),
            CGPointMake(0, CGFloat(arc4random() % 60)),
            CGPointMake(60, CGFloat(arc4random() % 60))
        ]
        CGContextBeginPath(context);
        CGContextAddLines(context, points, UInt(points.count));
        CGContextStrokePath(context);
    }
    
    func moveTo(pt: CGPoint)
    {
        UIView.beginAnimations("moveStone", context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(1.0)
    
        var rect: CGRect = self.frame
    
        rect.origin.x = pt.x - CHEESE_RADIUS;
        rect.origin.y = pt.y - CHEESE_RADIUS;
        // move to new location
        self.frame = rect;
    
        UIView.commitAnimations()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context)
        drawCheese(context)
        UIGraphicsPopContext()
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        UIView.beginAnimations("moveStone", context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(1.0)
        
        let touch: UITouch = touches.anyObject() as UITouch
        let pt = touch.locationInView(superview)
        var rect = frame
        rect.origin.x = pt.x - CHEESE_RADIUS
        rect.origin.y = pt.y - CHEESE_RADIUS
        frame = rect
        
        NSLog("[%@,%d] position= (%f,%f) -> (%f,%f)", __FUNCTION__, __LINE__,pt.x,pt.y,rect.origin.x,rect.origin.y)
        UIView.commitAnimations()
    }
}