//
//  Extensions.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/28/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//


import UIKit

//found serialized \ deserialized copy function...time saver
extension UILabel {
    func createCopy() -> UILabel {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as! UILabel
    }
    
    
   
}

extension UITableView{
    
    func addLayoutConstraints()
    {
        guard self != nil && self.superview != nil else{return}
        self.translatesAutoresizingMaskIntoConstraints = false
        self.insetsLayoutMarginsFromSafeArea = false
        let leftConstraint = NSLayoutConstraint(item: self,
                                                attribute: .trailing,
                                                relatedBy: .equal,
                                                toItem: self.superview!,
                                                attribute: .trailing,
                                                multiplier: 1.0,
                                                constant: 0.0)
        
        let rightConstraint = NSLayoutConstraint(item: self,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: self.superview!,
                                                attribute: .leading,
                                                multiplier: 1.0,
                                                constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: self.superview!,
                                                 attribute: .bottom,
                                                 multiplier: 1.0,
                                                 constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: self.superview!,
                                                  attribute: .top,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        
        self.superview!.addConstraint(leftConstraint)
        self.superview!.addConstraint(rightConstraint)
        self.superview!.addConstraint(bottomConstraint)
        self.superview!.addConstraint(topConstraint)
    }
}
