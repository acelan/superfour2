//
//  Board.swift
//  SuperFour2
//
//  Created by AceLan Kao on 2014/6/12.
//  Copyright (c) 2014年 AceLan Kao. All rights reserved.
//

import UIKit

class GameBoard : UIView {
    let UPPER_MARGIN: CGFloat = 200
    let LEFT_MARGIN:CGFloat = 50
    let RIGHT_MARGIN:CGFloat = 50
    let BOTTOM_MARGIN:CGFloat = 100
    let CHEESE_RADIUS: CGFloat = 25
    let row: UInt = 6
    let col: UInt = 7
    var lastMove: Int = -1
    
    var vcWidth: UInt
    var vcHeight: UInt
    var width: CGFloat
    var height: CGFloat
    var difficulty: UInt
    var board = Array<Array<UInt> >()
    var posBoard: Dictionary<NSIndexPath, CGPoint>
    
    init(frame: CGRect, difficulty d: UInt, w: UInt, h: UInt) {
        vcWidth = w
        vcHeight = h
        difficulty = d
        posBoard = Dictionary()
        width = CGFloat(vcWidth) - CGFloat(RIGHT_MARGIN) - CGFloat(LEFT_MARGIN)
        height = CGFloat(vcHeight) - CGFloat(BOTTOM_MARGIN) - CGFloat(UPPER_MARGIN)
        super.init(frame: frame)
        restart()
    }

    func restart() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        lastMove = -1
        for i in 0..col {
            var columnArray = Array<UInt>()
            for j in 0..row {
                columnArray.append(0)
            }
            board.append(columnArray)
        }
        
        posBoard.removeAll(keepCapacity: true)
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        drawBoard(rect, inContext: context);
        UIGraphicsPopContext();
    }
    
    func drawBoard(rect: CGRect, inContext context: CGContextRef) {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        
        CGContextSetLineWidth(context, 5.0);
        UIColor.whiteColor().setStroke()
        var x = 0
        var y = 0
        var startX: CGFloat = CGFloat(0) + CGFloat(LEFT_MARGIN)
        var startY: CGFloat = 0 + CGFloat(UPPER_MARGIN)
        
        var components: CGFloat[] = [ 0.4, 0.2, 0.3, 0.3]
        CGContextSetFillColor(context, components)
        CGContextFillRect(context, rect)
        
        CGContextBeginPath(context)
        CGContextAddRect(context, CGRectMake(startX, startY, width, height))
        CGContextStrokePath(context)
        
        CGContextSetFillColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextFillRect(context, CGRectMake(startX, startY, width, height))
        
        CGContextSetShadow(context, CGSizeMake(7, 7), 5.0)

        for i in 0..col {
            for j in 0..row {
                let pt = CGPointMake( startX + CGFloat(2) * CHEESE_RADIUS + CGFloat(i) * (startX + width - CGFloat(3)*CHEESE_RADIUS)/CGFloat(7)
                    , startY + 2 * CHEESE_RADIUS + CGFloat(j) * (startY + height - 3*CHEESE_RADIUS)/7)
                posBoard[ NSIndexPath(forRow: Int(i), inSection: 5 - Int(j))] = pt
                drawCircleAtPoint(pt, radius: CHEESE_RADIUS, inContext: context)
            }
        }
    }
    
    func drawCircleAtPoint(p: CGPoint, radius: CGFloat, inContext context: CGContextRef)
    {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        CGContextBeginPath(context);
        CGContextAddArc(context, p.x, p.y, radius, CGFloat(0), CGFloat(CDouble(2)*M_PI), 1);
        CGContextStrokePath(context);
    }
    
    func convertPositionToInteger(pt: CGPoint) -> NSInteger {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var i: NSInteger = 0
        while( i < 7) {
            let pi: CGPoint = posBoard[NSIndexPath(forRow: i, inSection: 0)]!
            let p1: CGPoint = posBoard[NSIndexPath(forRow: 1, inSection: 0)]!
            let p0: CGPoint = posBoard[NSIndexPath(forRow: 0, inSection: 0)]!
            if(pi.x - (p1.x - p0.x)/2 > pt.x) {
                break
            }
            i++
        }
        return NSInteger(i) - 1
    }
    
    func addStone(column: NSInteger) -> NSInteger
    {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var i: NSInteger = 0
        while i < 6 {
            if( board[ column][ i] == 0)
            {
                board[ column][ i] = 1;
                lastMove = column;
                break;
            }
            i++
        }
    
        if ( i == 6) {
            lastMove = -1;
        }
        lastMove = column;
        return lastMove;
    }
    
    func lastStonePosition() -> CGPoint
    {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var i: NSInteger = 0
        while( i < 6) {
            if (board[lastMove][i] == 0) {
                break;
            }
            i++
        }
        return posBoard[NSIndexPath(forRow: lastMove, inSection:i-1)]!
    }
    
    func isAValidPosition(pt: CGPoint) -> Bool {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        if (pt.y > UPPER_MARGIN) { return false }
        if (pt.x < LEFT_MARGIN || pt.x > RIGHT_MARGIN + width) { return false }
    
        // the column is not full yet
        var i: NSInteger = 0
        var column = convertPositionToInteger(pt)
        while( i < 6) {
            if( board[ column][ i] == 0) {
                return true
            }
            i++
        }
        if ( i == 6 ) { return false }
    
        return true;
    }
}
