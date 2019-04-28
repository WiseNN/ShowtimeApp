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
    
    @IBOutlet var tabBarHeightConstraint: NSLayoutConstraint!
    //class vars
    var movieTableView : UITableView!
    let movieTableViewManager = MovieTableViewManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //add resizing mask to main view for rotation
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.setNeedsDisplay()
        //create movie movieTableview
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        print("navHeight: \(navBarHeight)")
        let tvFrame = CGRect(x: 0,y: navBarHeight,width: self.view.bounds.width,height: self.view.bounds.height)
        print("height: \(categoryTabBar.bounds.height)")
        movieTableView = UITableView(frame: tvFrame, style: .plain)
        self.movieTableView.backgroundColor = UIColor.black
        //set datasource/delegate for moviewTableView
        movieTableView.delegate = movieTableViewManager
        movieTableView.dataSource = movieTableViewManager
        ////add resizing mask to movieTableView rotation
        movieTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //register nib with moviewTableView
        movieTableView.register(UINib(nibName: MovieConst.config.nibName, bundle: nil), forCellReuseIdentifier: MovieConst.config.cellReuseID)
        //turn-on prefetching
        movieTableView.prefetchDataSource = (movieTableViewManager as! UITableViewDataSourcePrefetching)
        //add movieTableView as subview to main view
        self.view.insertSubview(movieTableView, belowSubview: categoryTabBar)
        
        
        
        //set categoryTabBar delegate
        categoryTabBar.delegate = self
        
        
        
    }
    
    @objc func refreshTableView()
    {
        self.movieTableView.reloadData()
        self.movieTableView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabViewController.refreshTableView), name: MovieConst.notifications.refreshTable, object: nil)
        //show first tab on load
//        self.movieTableViewManager.presentTabTag = 0
        //select first tab on default
//        self.categoryTabBar.selectedItem = self.categoryTabBar.items![movieTableViewManager.presentTabTag]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: MovieConst.notifications.refreshTable, object: nil)
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        
        //disable in select
        categoryTabBar.items!.forEach({$0.isEnabled = true})
        item.isEnabled = false
        //update observable in movie manager based on tag tag
        movieTableViewManager.presentTabTag = item.tag
        print("Selected Tab: \(item.tag)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

