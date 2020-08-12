//
//  ViewController.swift
//  TimeUIList
//
//  Created by 335074307@qq.com on 11/07/2019.
//  Copyright (c) 2019 335074307@qq.com. All rights reserved.
//

import UIKit
import TimeUIList
import SwiftProjects
import NFAToolkit

class ViewController: UIViewController {

    lazy var showOneTime : OneTimeView = {
           let showTime =  OneTimeView.sharedInstance()
           showTime.frame = UIScreen.main.bounds
           return showTime
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Tools.delay(1) {
            let pop =  PopupController.create(self)?.customize([ .animation(.none), .scrollable(false), .backgroundStyle(.blackFilter(alpha: 0.3)) ])
            let vw = TimePopView()
            vw.initializeData()
//            vw.minimumDate = Date()
            vw.regCallBack {(data) in
                pop?.dismiss()
            }
            pop?.show(vw)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

