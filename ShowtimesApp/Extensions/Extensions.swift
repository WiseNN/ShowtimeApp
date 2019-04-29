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
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: 0)
            ])
    }
}
