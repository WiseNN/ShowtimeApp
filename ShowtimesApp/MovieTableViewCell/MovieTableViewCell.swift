//
//  MovieTableViewCell.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/27/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var posterPathImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieOverviewLabel : UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        posterPathImageView.layer.borderColor = UIColor.orange.cgColor
//        posterPathImageView.layer.borderWidth = 4
        
    }

    func startOverviewScrollAnimation()
    {
        //hide overview label

        //create parentView for masked presentation view for overviewLabel,
        //  mask & clip to bounds, add to contentView
        let movieOverViewLabelCopy = self.movieOverviewLabel.createCopy()
        let parentView = UIView(frame: self.movieOverviewLabel.frame)
        parentView.autoresizingMask = self.movieOverviewLabel.autoresizingMask
        movieOverViewLabelCopy.frame = parentView.bounds
        movieOverViewLabelCopy.bounds = parentView.bounds
        parentView.clipsToBounds = true
        parentView.layer.masksToBounds = true
        parentView.addSubview(movieOverViewLabelCopy)
        parentView.tag = 543
        
        self.contentView.addSubview(parentView)
        
        //create scrol anim cycle for overview label
        CATransaction.begin()
        let currentPoint = CGPoint(x: self.movieOverviewLabel.layer.frame.minX, y: self.movieOverviewLabel.layer.frame.minY)
        let duration = 6.0
        //scroll up out of view from original position
        let scrollAnimFirst = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        scrollAnimFirst.fromValue = currentPoint
        scrollAnimFirst.toValue = CGPoint(x: currentPoint.x, y: -parentView.bounds.height)
//        scrollAnimFirst.repeatCount = Float.infinity
        scrollAnimFirst.duration = duration
        scrollAnimFirst.beginTime = 0.0
//        scrollAnimFirst.fillMode = kCAFillModeForwards
        
        
        //scroll up out of view from bottom of screen
        let scrollAnimSecond = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        scrollAnimSecond.fromValue = CGPoint(x: currentPoint.x, y: parentView.frame.maxY)
        scrollAnimSecond.toValue = currentPoint
//        scrollAnimSecond.repeatCount = Float.infinity
        scrollAnimSecond.duration = scrollAnimFirst.duration
        scrollAnimSecond.beginTime = scrollAnimFirst.duration
        scrollAnimSecond.fillMode = kCAFillModeBackwards
        
        self.movieOverviewLabel.alpha = 0
        let scrollAnimGroup = CAAnimationGroup()
        scrollAnimGroup.animations = [ scrollAnimSecond,scrollAnimFirst]
        scrollAnimGroup.duration = scrollAnimFirst.duration + scrollAnimSecond.duration
        scrollAnimGroup.repeatCount = Float.infinity
        scrollAnimGroup.beginTime = 0.0
        scrollAnimGroup.speed = 1.3 * scrollAnimGroup.speed
        
        movieOverViewLabelCopy.layer.add(scrollAnimGroup, forKey: nil)
        CATransaction.commit()
        
    }
    
    func stopOverviewScrollingAnimation()
    {
        guard let parentView = self.contentView.viewWithTag(543) else{return}
        parentView.removeFromSuperview()
        print("removed parentView")
        //show overview label
        self.movieOverviewLabel.alpha = 1
        
    }
    
    
}
