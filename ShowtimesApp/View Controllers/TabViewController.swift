//
//  ViewController.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/26/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import UIKit

class TabViewController: UIViewController, UITabBarDelegate
{
    //outlets
    @IBOutlet var categoryTabBar: UITabBar!
    
    
    
    //class vars
    var movieTableView : UITableView!
    let movieTableViewManager = MovieTableViewManager()
   
    
    
    
    //stop possible animation before rotation
    override var shouldAutorotate: Bool{
        guard self.movieTableView != nil else{return true}
        self.stopTableViewCellAnimHelper()
//        self.movieTableView.layoutIfNeeded()
        return true
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //add translucence  to nav bar
        self.navigationController!.navigationBar.alpha = 0.5
        //add resizing mask to main view for rotation
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.setNeedsDisplay()
        //create movie movieTableview
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        print("navHeight: \(navBarHeight)")
//        let tvFrame = CGRect(x: 0,y: navBarHeight,width: self.view.bounds.width,height: self.view.bounds.height)
        print("height: \(self.categoryTabBar.bounds.height)")
        self.movieTableView = UITableView()
        self.view.insertSubview(self.movieTableView, at: 0)
        self.movieTableView.addLayoutConstraints()
        ////add resizing mask to movieTableView rotation
        self.movieTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.movieTableView.backgroundColor = UIColor.black
        //set datasource/delegate for moviewTableView
        self.movieTableView.delegate = self.movieTableViewManager
        self.movieTableView.dataSource = self.movieTableViewManager
        self.movieTableView.tag = MovieConst.tags.movieTableViewTag
        //register nib with moviewTableView
        self.movieTableView.register(UINib(nibName: MovieConst.config.nibName, bundle: nil), forCellReuseIdentifier: MovieConst.config.cellReuseID)
        //turn-on prefetching
        self.movieTableView.prefetchDataSource = (self.movieTableViewManager as! UITableViewDataSourcePrefetching)
        //add movieTableView as subview to main view

        //set categoryTabBar delegate
        self.categoryTabBar.delegate = self
        
        
        
    }
    
   
    @objc func refreshTableView()
    {
        
        self.movieTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabViewController.refreshTableView), name: MovieConst.notifications.refreshTable, object: nil)
        //select first tab on load
        self.tabBar(self.categoryTabBar, didSelect: self.categoryTabBar.items!.first!)
        //select first cell 3 on load in tableView
        
        
//        self.categoryTabBar.selectedItem = self.categoryTabBar.items![self.movieTableViewManager.presentTabTag]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: MovieConst.notifications.refreshTable, object: nil)
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        
        self.stopTableViewCellAnimHelper()
        //disable in select
        self.categoryTabBar.items!.forEach({$0.isEnabled = true})
        item.isEnabled = false
        //update observable in movie manager based on tag tag
        self.movieTableViewManager.presentTabTag = item.tag
        print("Selected Tab: \(item.tag)")
    }

    func stopTableViewCellAnimHelper()
    {
        //stop possible movieTableView scroll animation
        if let selectedIndexPath = self.movieTableView.indexPathForSelectedRow
        {
            guard let movieCell = self.movieTableView.cellForRow(at: selectedIndexPath) as? MovieTableViewCell else{return}
            movieCell.stopOverviewScrollingAnimation()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

