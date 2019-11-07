//
//  OneTimeView.swift
//  FBSnapshotTestCase
//
//  Created by 聂飞安 on 2019/11/7.
//

import UIKit

public class OneTimeView: UIView {

    private static var instance : OneTimeView!
    
    open class func sharedInstance() -> OneTimeView {
        if instance == nil {
           instance = Bundle(for: self.classForCoder()).loadNibNamed("TimeUIList.bundle/OneTimeView", owner: self, options: nil)?.first as? OneTimeView
        }
        return instance

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
