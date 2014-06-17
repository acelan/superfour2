//
//  Brain.swift
//  SuperFour2
//
//  Created by AceLan Kao on 2014/6/15.
//  Copyright (c) 2014年 AceLan Kao. All rights reserved.
//

import Foundation
import UIKit

class Brain : NSObject {
    var board = Array<Array<NSInteger>>()
    var backupBoard = Array<Array<NSInteger>>()
    var scoreMap = Array<Array<NSInteger>>()
    var gameOver: Bool
    
    let USER: NSInteger = 1
    let COMPUTER: NSInteger = 2
    
    init() {
        gameOver = false
        
        super.init()
        
        initBoard()
        initScoreMap()
    }
    
    func initBoard() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
/*
        for i in 0..7 {

            var columnArray = Array<NSInteger>()
            for j in 0..6 {
                columnArray.append(0)
            }
            board.append(columnArray)

        }
*/

        for column in 0..7 {
            board.append(Array(count:6, repeatedValue:NSInteger()))
            backupBoard.append(Array(count:6, repeatedValue:NSInteger()))
        }

//        board = Array(count:7, repeatedValue: Array(count:6, repeatedValue: NSInteger(0)))
//        backupBoard = Array(count:7, repeatedValue: Array(count:6, repeatedValue: NSInteger(0)))
    }
    
    func initScoreMap() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
/*
        for i in 0..7 {

            var columnArray = Array<NSInteger>()
            for j in 0..6 {
                columnArray.append(0)
            }
            scoreMap.append(columnArray)

        }
*/

        for column in 0..7 {
            scoreMap.append(Array(count:6, repeatedValue:NSInteger()))
        }

//        board = Array(count:6, repeatedValue: Array(count:7, repeatedValue: NSInteger(0)))
    }

    func restart() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        gameOver = false
        initBoard()
        initScoreMap()
    }
    
    func isGameOver() -> Bool {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        return gameOver
    }
    
    func isAValidPosition( column: NSInteger) -> Bool {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        if(board[column][5] == 0) {
            return true
        }
        return false
    }
    
    func isAValidPosition( x: NSInteger, y: NSInteger) -> Bool {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        if(board[x][y] == 0) {
            if( y == 0) {
                return true
            } else if( board[x][y-1] != 0) {
                return true
            }
        }
        
        return false
    }
    
    func addStone(who: NSInteger, column: NSInteger) {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        for i in 0..6 {
            if(board[Int(column)][Int(i)] == 0) {
                board[Int(column)][Int(i)] = who
                break
            }
        }
    }
    
    func computerAddStone() -> NSInteger {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var column: NSInteger

        updateScoreMap()
        column = getHightestScoreLocation()
        addStone(COMPUTER, column: column)
        gameOver = willWin(COMPUTER, column: column)
        
        return column
    }
    
    func userAddStoneAt(column: NSInteger) {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        addStone(USER, column: column)
        gameOver =  willWin(USER, column: column)
        // It's impossible that user add the stone in the wrong column
    }
    
    func getScore(who: NSInteger, x: NSInteger, y: NSInteger) -> NSInteger {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var i: NSInteger = x
        var j = y
        var steps: NSInteger = 0
        var enemy: NSInteger = USER + COMPUTER - who
        var score: NSInteger = 0
        var line: NSInteger = 5
        var pp: NSInteger = 8					// one line can get 5 score, one stone can get 8 score
    
        // to right
        i = x;
        while( ( board[ i][ j] != enemy)	// no enemy stone
               && ( i < 6)) {					// within the board
            i++;							// move one step to right
            if( board[ i][ j] != enemy) {		// right location doesn't have enemy's stone
                steps++;					// it's empty or might be our stone
                if( board[ i][ j] == who) {	// it's our stone on the right
				    score += pp;				// add the score because of the connection
                }
            }
            else {
                break;
            }
        }
        if( steps >= 3)						// There are 3 more space can move forward
        {
            score += line;					// This location can earn the score of line
            steps = 0;						// recount the steps while walking to left
            // we don't have to reset the value if the steps is not 3
        }
    
        // to left
        i = x;
        while( ( board[ i][ j] != enemy) && ( i > 0))
        {
            i--;							// move one step to left
            if( board[ i][ j] != enemy)
            {
                steps++;
                if( board[ i][ j] == who) {
	    			score += pp;
                }
            }
            else {
                break;
            }
        }
        if( steps >= 3) {
            score += line;
        }
    
        // to down
        steps = 0;
        i = x
        j = y;
        while( ( board[ i][ j] != enemy) && ( j > 0))
        {
            j--;
            if( board[ i][ j] != enemy)
            {
                steps++;
                if( board[ i][ j] == who) {
    				score += pp;
                }
            }
            else {
                break;
            }
        }
        if( steps + ( 6 - y) >= 3) {			// the space can move down and plus the space above
            score += line;
        }
    
        //算斜的..
        //往左下走
        steps = 0;
        i = x
        j = y;
        while( ( board[ i][ j] != enemy) && ( i > 0) && ( j > 0))
        {
            i--;
            j--;
            if( board[ i][ i] != enemy)
            {
                steps++;
                if( board[ i][ j] == who) {
    				score += pp;
                }
            }
            else {
                break;
            }
    
            if( steps == 3) {
                break;
            }
        }
        if( steps == 3)
        {
            score += line;
            steps = 0;                       // we don't have to reset the value if the steps is not 3
        }
        //往右上走
        i = x
        j = y;
        while( ( board[ i][ j] != enemy) && ( i < 6) && ( j < 5))
        {
            i++;
            j++;
            if( board[ i][ j] != enemy)
            {
                steps++;
                if( board[ i][ j] == who) {
    				score += pp;
                }
            }
            else {
                break;
            }
    
            if( steps == 3) {
                break;
            }
        }
        if( steps == 3) {
            score += line;
        }
    
        //往右下走
        steps = 0;
        i = x
        j = y;
        while( ( board[ i][ j] != enemy) && ( i < 6) && ( j > 0))
        {
            i++;
            j--;
            if( board[ i][ j] != enemy)
            {
                steps++;
                if( board[ i][ j] == who) {
    				score += pp;
                }
            }
            else {
                break;
            }
    
            if( steps == 3) {
                break;
            }
        }
        if( steps == 3)
        {
            score += line;
            steps = 0;
        }
        //往左上走
        i = x
        j = y;
        while( ( board[ i][ j] != enemy) && ( i > 0) && ( j < 5))
        {
            i--;
            j++;
            if( board[ i][ j] != enemy)
            {
                steps++;
                if( board[ i][ j] == who) {
	    			score += pp;
                }
            }
            else {
                break;
            }
    
            if( steps == 3) {
                break;
            }
        }
        if( steps == 3) {
            score += line;
        }
        
        printScoreMap()
        return score;
    }

    func printScoreMap() {
        var j = 5;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", scoreMap[0][j], scoreMap[1][j], scoreMap[2][j], scoreMap[3][j], scoreMap[4][j], scoreMap[5][j], scoreMap[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", scoreMap[0][j], scoreMap[1][j], scoreMap[2][j], scoreMap[3][j], scoreMap[4][j], scoreMap[5][j], scoreMap[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", scoreMap[0][j], scoreMap[1][j], scoreMap[2][j], scoreMap[3][j], scoreMap[4][j], scoreMap[5][j], scoreMap[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", scoreMap[0][j], scoreMap[1][j], scoreMap[2][j], scoreMap[3][j], scoreMap[4][j], scoreMap[5][j], scoreMap[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", scoreMap[0][j], scoreMap[1][j], scoreMap[2][j], scoreMap[3][j], scoreMap[4][j], scoreMap[5][j], scoreMap[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", scoreMap[0][j], scoreMap[1][j], scoreMap[2][j], scoreMap[3][j], scoreMap[4][j], scoreMap[5][j], scoreMap[6][j]);
        NSLog("------------------------------------");
    }
    
    func printBoard() {
        var j = 5;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", board[0][j], board[1][j], board[2][j], board[3][j], board[4][j], board[5][j], board[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", board[0][j], board[1][j], board[2][j], board[3][j], board[4][j], board[5][j], board[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", board[0][j], board[1][j], board[2][j], board[3][j], board[4][j], board[5][j], board[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", board[0][j], board[1][j], board[2][j], board[3][j], board[4][j], board[5][j], board[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", board[0][j], board[1][j], board[2][j], board[3][j], board[4][j], board[5][j], board[6][j]);
        j--;
        NSLog("%4d %4d %4d %4d %4d %4d %4d", board[0][j], board[1][j], board[2][j], board[3][j], board[4][j], board[5][j], board[6][j]);
        NSLog("------------------------------------");
    }
    
    func pushBoard()
    {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        for i in 0..7 {
            for j in 0..6 {
                backupBoard[ i][ j] = board[ i][ j];
            }
        }
    }
    
    func popBoard()
    {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        for i in 0..7 {
            for j in 0..6 {
                board[ i][ j] = backupBoard[ i][ j];
            }
        }
    }
    
    func getRowFromColumn( column: NSInteger) -> NSInteger {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var j: NSInteger = 0
        while( j > 0) {
            if (board[column][j] != 0) {
                break;
            }
            j--
        }
    
        return j;			// j will become -1 if can't find the row number
    }
    
    func willWin(who: NSInteger, column: NSInteger) -> Bool
    {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var x = column
        var y = getRowFromColumn(column)
        var i = x
        var j = y
        var steps: NSInteger = 0
        var counter: NSInteger = 0;
    
        // 往下
        if( j >= 3) {			// there are enough space to have 4 stones
            if( board[i][j] == board[i][j-1] && board[i][j-1] == board[i][j-2] && board[i][j-2] == board[i][j-3] && board[i][j] == who) {
                return true;
            }
        }
    
        // 水平
        var counter1 = 1
        var counter2 = 1
        i = x
        j = y
        // 右邊空間
        while( i < 6 && counter1 < 4) {
            i++
            counter1++
        }
        i = x
        j = y
        // 左邊空間
        while( i > 0 && counter2 < 4) {
            i--
            counter2++
        }
        // not enough space?
        counter = counter1 + counter2 - 1;
        if( counter < 4 ) {
            return false;
        }
    
        steps = 0
        while( counter > 0) {
            if( board[i][j] == who) {
                steps++;
            }
            else {
                steps = 0;
            }
    
            if( steps == 4) {
                return true
            }
            counter--
            i++
        }
    
        // 右上左下
        counter1 = 1
        counter2 = 1
        i = x
        j = y
        // 右上空間
        while( i < 6 && j < 5 && counter1 < 4) {
            i++
            j++
            counter1++
        }
        i = x
        j = y;
        // 左下空間
        while( i > 0 && j > 0 && counter2 < 4) {
            i--
            j--
            counter2++;
        }
        // not enough space?
        counter = counter1 + counter2 - 1;
        if( counter < 4) {
            return false;
        }
    
        steps = 0
        while( counter > 0) {
            if( board[i][j] == who) {
                steps++;
            }
            else {
                steps = 0;
            }
    
            if( steps == 4) {
                return true;
            }
            counter--
            i++
            j++
        }
    
        // 左上右下
        counter1 = 1
        counter2 = 1;
        i = x
        j = y;
        // 左上空間
        while( i > 0 && j < 5 && counter1 < 4) {
            i--
            j++
            counter1++
        }
        i = x
        j = y;
        // 右下空間
        while( i < 6 && j > 0 && counter2 < 4) {
            i++
            j--
            counter2++;
        }
        // not enough space?
        counter = counter1 + counter2 - 1;
        if( counter < 4) {
            return false;
        }
    
        steps = 0
        while( counter > 0) {
            if( board[i][j] == who) {
                steps++;
            }
            else {
                steps = 0;
            }
    
            if( steps == 4) {
                return true
            }
            counter--
            i--
            j++
        }
    
        return false;
    }

    func updateScoreMap() {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        // clear score map
        for i in 0..7 {
            for j in 0..6 {
                scoreMap[ i][ j] = 0;
            }
        }
        
        // calculate score by stones
        for i in 0..7 {
            for j in 0..6 {
                if( isAValidPosition(i, y: j))
                {
                    scoreMap[ i][ j] = getScore(COMPUTER, x: i, y: j)
                    scoreMap[ i][ j] += getScore(USER, x: i, y: j)
                }
            }
        }
        
        // find if there exist a 2 stones pattern that do not be blocked by computer's stones
        for i in 0..4 {
            var j = i + 1
            while (j <= i+3) {
                pushBoard()
                addStone(USER, column: i)
                addStone(USER, column: j)
                
                NSLog("[%@,%d] yooooooooooooo", __FUNCTION__, __LINE__)
                printBoard()
                do {
                    if (willWin(USER, column: i)) {
                        var m = getRowFromColumn(i)
                        var n = getRowFromColumn(j)
                        var ratio = (n-m)/(j-i);
                        
                        // special live patterns
                        if ( ( i == 0) && ( j == i + 3) && (board[j+1][n+ratio] == 0)) { scoreMap[j][n] = 800; break; }
                        if ( ( j == 6) && ( i == j - 3) && (board[i-1][m+ratio] == 0)) { scoreMap[i][m] = 800; break; }
                        
                        // a hole in between the 2 stones
                        if ( ( j - i) == 2) {
                            NSLog("yooooooooooooooooooooooooooo")
                            if ( (board[i-1][m+ratio] == 0) && (board[j+2][n+ratio] == 0)) { scoreMap[j][n] = 800; break; }
                        } else {	// two connected stones
                            if ((i>=2) && (board[i-2][m+ratio] == 0)) { scoreMap[i][m] = 800; break; }
                            if ((j<=4) && (board[j+2][n+ratio] == 0)) { scoreMap[j][n] = 800; break; }
                        }
                    }
                } while( false );
                
                popBoard()
                j++
            }
        }
        
        // find if there exist a 2 stones pattern that do not be blocked by user's stones
        for i in 0..4 {
            var j = i+1
            while (j <= 3) {
                pushBoard()
                addStone(COMPUTER, column: i)
                addStone(COMPUTER, column: j)
                do {
                    if (willWin(COMPUTER, column: i)) {
                        var m = getRowFromColumn(i)
                        var n = getRowFromColumn(j)
                        var ratio = (n-m)/(j-i);
                        
                        // special live patterns
                        if ( ( i == 0) && ( j == i + 3) && (board[j+1][n+ratio] == 0)) { scoreMap[j][n] = 850; break; }
                        if ( ( j == 6) && ( i == j - 3) && (board[i-1][m+ratio] == 0)) { scoreMap[i][m] = 850; break; }
                        
                        // a hole in between the 2 stones
                        if ( ( j - i) == 2) {
                            if ( (board[i-1][m+ratio] == 0) && (board[j+2][n+ratio] == 0)) { scoreMap[j][n] = 850; break; }
                        } else {	// two connected stones
                            if ((i>=2) && (board[i-2][m+ratio] == 0)) { scoreMap[i][m] = 850; break; }
                            if ((j<=4) && (board[j+2][n+ratio] == 0)) { scoreMap[j][n] = 850; break; }
                        }
                    }
                } while (false);
                
                popBoard()
                j++
            }
        }
        
        // decrease the score if the location will kill ourself
        for i in 0..7 {
            pushBoard()
            addStone(USER, column: i)
            addStone(COMPUTER, column: i)		// if we can win at this location, then we shouldn't put stone at this location before user
            if (willWin(COMPUTER, column: i)) {
                scoreMap[ i][getRowFromColumn(i)-1] = -1;
            }
            popBoard()
        }
        
        // decrease the score if the location will help user
        for i in 0..7 {
            pushBoard()
            addStone(COMPUTER, column: i)
            addStone(USER, column: i)			// if user can win at this location, then we shouldn't put stone at this location
            if (willWin(USER, column: i)) {
                scoreMap[ i][getRowFromColumn(i)-1] = -2;
            }
            popBoard()
        }
        
        // recalculate score by adding one more stone for user
        for i in 0..7 {
            if (!isAValidPosition(i)) {
                continue
            }
            
            pushBoard()
            addStone(USER, column: i)
            if (willWin(USER, column: i)) {
                scoreMap[ i][getRowFromColumn(i)] = 900;
            }
            popBoard()
        }
        
        // recalculate score by adding one more stone for computer
        for i in 0..7 {
            if (!isAValidPosition(i)) {
                continue
            }
            
            pushBoard()
            addStone(COMPUTER, column: i)
            if (willWin(COMPUTER, column: i)) {
                scoreMap[ i][getRowFromColumn(i)] = 999;
            }
            popBoard()
        }
        
        //	[self printScoreMap];
        printBoard()

    }
    
    func getHightestScoreLocation() -> NSInteger {
        NSLog("[%@,%d]", __FUNCTION__, __LINE__)
        var score: NSInteger = -2;								//最低分
        var posi: NSInteger = -1;
        
        for i in 0..7 {
            for j in 0..6 {
                if( scoreMap[ i][ j] >= score) {		//分數地圖中有比目前最高分還高的分數
                    if( isAValidPosition(i, y: j))	//是可以下子的位置嗎...
                    {
                        score = scoreMap[ i][ j];		//那就取出此分數
                        posi = i;						//並記錄下這個位置
                    }
                }
            }
        }
        return posi;
    }
}