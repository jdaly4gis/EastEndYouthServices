//
//  FacilityDetails.swift
//  EastEndYouthServices
//
//  Created by Southampton Dev on 8/25/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit

class FacilityDetails: UIView {
    
    var title: String
    var desc: String
    
//    override init(frame:CGRect) {
//        super.init(frame:frame)
//    }
    
    init(frame: CGRect, facility: Facility){
        
        self.title = facility.F_Name!
        self.desc = facility.Desc!

        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
//        let testButton = UIButton(type: UIButtonType.System)
//        testButton.backgroundColor = UIColor.orangeColor()
//        testButton .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        testButton.setTitle(self.ti, forState: UIControlState.Normal)
//        testButton.frame = CGRectMake(0,100, 100, 50)
        
        let labelDynamicLabel = UILabel()
        labelDynamicLabel.backgroundColor = UIColor.orangeColor()
        labelDynamicLabel.text = "A Dynamic Label"
        labelDynamicLabel.translatesAutoresizingMaskIntoConstraints = false
        labelDynamicLabel.frame = CGRectMake(100,100, 100, 200)

        addSubview(labelDynamicLabel)
        /*

        let leadingSpaceConstraint: NSLayoutConstraint = NSLayoutConstraint(item: labelDynamicLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: labelDynamicLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0);
        
        let topSpaceConstraint: NSLayoutConstraint = NSLayoutConstraint(item: labelDynamicLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: labelDynamicLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10);
        

        addConstraint(leadingSpaceConstraint)
        addConstraint(topSpaceConstraint)
 */

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 