//
//  SuperFourGame.swift
//  SuperFour2
//
//  Created by AceLan Kao on 2014/6/6.
//  Copyright (c) 2014年 AceLan Kao. All rights reserved.
//

import UIKit

class SuperFourGameViewController : UIViewController {
    var game: GameboardView?
    override func viewDidLoad() {
        super.viewDidLoad();
        game = GameboardView(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
        view.addSubview(game)
    }
}
