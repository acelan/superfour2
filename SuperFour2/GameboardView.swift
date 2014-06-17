//
//  GameboardView.swift
//  SuperFour2
//
//  Created by AceLan Kao on 2014/6/6.
//  Copyright (c) 2014年 AceLan Kao. All rights reserved.
//

import UIKit

class GameboardView : UIView {
    let STONE_START_X: CGFloat = 730
    let STONE_START_Y: CGFloat = 130
    let CHEESE_RADIUS: CGFloat = 32		// a little bigger than real stone
    
    var difficulty: Int?
    //var gameboard: GameboardView?
    var gameboard: GameBoard
    var brain: Brain
    var stone: Stone
    
    init(frame: CGRect) {
        let vcWidth: CGFloat = frame.size.width
        let vcHeight: CGFloat = frame.size.height
        
        gameboard = GameBoard(frame: CGRectMake(0, 0, vcWidth, vcHeight), difficulty: UInt(0), w: UInt(vcWidth), h: UInt(vcHeight))
        brain = Brain()
        stone = Stone(frame: CGRectMake(STONE_START_X-CHEESE_RADIUS, STONE_START_Y-CHEESE_RADIUS, CHEESE_RADIUS*2, CHEESE_RADIUS*2), color: UIColor.redColor())
        
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        setupGame()
    }
    
    func setupGame() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        addSubview(gameboard)
        
        gameLoop(0)
    }
    
    func gameOverAlert(winner: NSString)
    {
        var msg: NSString = NSString(format: "%@ wins", winner)
        var message = UIAlertView(title: "Game Over!",
            message: msg,
            delegate: self,
            cancelButtonTitle: "Again")
        message.show();
    }
    
    func alertView(alertView: UIAlertView, buttonIndex: NSInteger)
    {
        switch (buttonIndex) {
        case 0:
            restart()
            break;
        default:
            break
        }
    }
    
    func gameLoop(player: NSInteger) {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        if (player == 0) {
            // a stone for user
            stone = Stone(frame: CGRectMake(STONE_START_X-CHEESE_RADIUS, STONE_START_Y-CHEESE_RADIUS, CHEESE_RADIUS*2, CHEESE_RADIUS*2), color: UIColor.redColor())
            
            addSubview(stone)
        } else {
            // a new stone for computer
            stone = Stone(frame: CGRectMake(STONE_START_X-30, STONE_START_Y-30, 60, 60), color: UIColor.blueColor())
            
            stone.userInteractionEnabled = false;
            addSubview(stone)
            
            var column: NSInteger = brain.computerAddStone()
            //		NSLog(@"computer column: %d", column);
            if (column < 0) {
                // computer lose
            }
            gameboard.addStone(column)
            stone.moveTo(CGPointMake(gameboard.lastStonePosition().x, 100))
            stone.moveTo(gameboard.lastStonePosition())
            stone.userInteractionEnabled = false
            
            if (brain.isGameOver()) {
                gameOverAlert("Computer")
            }
            else {
                gameLoop(0)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        if (!stone.userInteractionEnabled) { return; }
        
        var touch: UITouch = touches.anyObject() as UITouch
        var pt: CGPoint = touch.locationInView(self)
        NSLog("touchended: (%f,%f)", pt.x , pt.y);
        
        // It's a random touch, not moving the stone
        if ( ( stone.frame.origin.x == STONE_START_X-CHEESE_RADIUS) && (stone.frame.origin.y == STONE_START_Y-CHEESE_RADIUS)) {
            return
        }
        
        if ( gameboard.isAValidPosition(pt)) {
            stone.userInteractionEnabled = false;
            var column: NSInteger = gameboard.addStone(gameboard.convertPositionToInteger(pt))
            //		NSLog(@"user column: %d", column);
            brain.userAddStoneAt(column)
            stone.moveTo(gameboard.lastStonePosition())
            
            if (brain.isGameOver()) {
                gameOverAlert("User")
            } else {
                gameLoop(1)
            }
        } else {
            stone.moveTo(CGPointMake(STONE_START_X, STONE_START_Y))
        }
    }
    
    func restart() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var i: NSInteger = 0
        for view in self.subviews {
            i++;
            if (i == 1) {        // don't release board
                continue;
                view.removeFromSuperview()
            }
        }
        
        gameboard.restart()
        brain.restart()
        gameLoop(0)
    }

}
