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
    @IBOutlet var movieOverviewTextView : UITextView!
    
    //class vars
    var shouldAnimate : Bool = false
    var animTimer : Timer?
    
    
    var duration : Double = 8
    
    func animateScrollView(duration: Double, to newBounds: CGRect) {
        
        let scrollView = self.movieOverviewTextView as UIScrollView
        let scrollAnim = CABasicAnimation(keyPath: #keyPath(CALayer.bounds))
//        scrollView.contentOffset.y = 0
        scrollAnim.duration = duration
        scrollAnim.fromValue = scrollView.bounds
        scrollAnim.toValue = newBounds
        scrollAnim.autoreverses = true
        scrollAnim.repeatCount = Float.infinity
        scrollAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.movieOverviewTextView.layer.add(scrollAnim, forKey: nil)

    }
    
    func startOverviewScrollAnimation()
    {
        let scrollView = self.movieOverviewTextView as UIScrollView
        guard scrollView.contentSize.height > self.movieOverviewTextView.bounds.height else{return}
        let offsetY = scrollView.contentSize.height - self.movieOverviewTextView.bounds.height
        let newOrigin = CGPoint(x: scrollView.bounds.origin.x, y: offsetY)
        self.animateScrollView(duration: 5.0, to: CGRect(origin: newOrigin, size: scrollView.bounds.size))
    }
    
    func stopOverviewScrollingAnimation()
    {

        let scrollView = self.movieOverviewTextView as UIScrollView
        scrollView.layer.removeAllAnimations()
    }
    
    
}
