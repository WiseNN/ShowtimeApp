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
