//
//  ViewController.swift
//  SuperFour2
//
//  Created by AceLan Kao on 2014/6/5.
//  Copyright (c) 2014年 AceLan Kao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    @IBAction func startGameButtonTapped(sender: UIButton) {
        let game = SuperFourGameViewController()
        //let game = GameboardView()
        view.backgroundColor = UIColor.darkGrayColor()
        self.presentViewController(game, animated: true, completion: nil)
    }
}
