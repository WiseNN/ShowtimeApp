//
//  MovieNavigationController.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/29/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import UIKit

class MovieNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    override var shouldAutorotate: Bool {
        return self.visibleViewController!.shouldAutorotate
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
