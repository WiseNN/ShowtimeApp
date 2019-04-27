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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //add resizing mask to main view for rotation
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //create movie movieTableview
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        let tvFrame = CGRect(x: 0,y: navBarHeight,width: self.view.bounds.width,height: self.view.bounds.height - categoryTabBar.bounds.height - navBarHeight)
        movieTableView = UITableView(frame: tvFrame, style: .plain)
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
        self.view.addSubview(movieTableView)
        //select first tab on default
        self.categoryTabBar.selectedItem = self.categoryTabBar.items![movieTableViewManager.presentTabTag]
        
        //set categoryTabBar delegate
        categoryTabBar.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //show first tab on load
        self.movieTableViewManager.presentTabTag = 0
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        //if tab is already selected, ignore event
        guard self.categoryTabBar.selectedItem!.tag != item.tag else{return}
        
        //update observable in movie manager based on tag tag
        movieTableViewManager.presentTabTag = item.tag
        print("Selected Tab: \(item.tag)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

