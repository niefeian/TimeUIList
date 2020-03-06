//
//  ViewController.swift
//  TimeUIList
//
//  Created by 335074307@qq.com on 11/07/2019.
//  Copyright (c) 2019 335074307@qq.com. All rights reserved.
//

import UIKit
import TimeUIList
class ViewController: UIViewController {

    lazy var showOneTime : OneTimeView = {
           let showTime =  OneTimeView.sharedInstance()
           showTime.frame = UIScreen.main.bounds
           return showTime
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(showOneTime)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

