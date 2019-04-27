//
//  MovieTableViewDelegate.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/27/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import UIKit

class MovieTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching
{
    
    
    
    
    //data model vars
        //set present tab
    var presentTabTag : Int! {
        didSet{
            changeModelHelper(forTag: presentTabTag)
        }
    }
    private var nowPlayingDictionary : [MovieModel]?
    private var popularMoviesModel : [MovieModel]?
    private var topRatedModel : [MovieModel]?
    private var upcomingModel : [MovieModel]?
    var tableViewModelAry : [MovieModel]?
        //instantiate downloader
    let downloader : Downloader =  {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        return Downloader(configuration: config)
    }()
    
    
    
    private func changeModelHelper(forTag : Int)
    {
        //will not check for redundant loads here, outsourcing to TabVC delegate,
        //  first line of defense will do just fine in example app
        
        switch forTag
        {
            case 0:
                guard let npModel = self.nowPlayingDictionary else{
                    self.loadModel(withURL: MovieConst.urls.nowPlaying)
                }
                self.tableViewModelAry = npModel
                break
            case 1:
                guard let pmModel = self.popularMoviesModel  else{
                    self.loadModel(withURL: MovieConst.urls.popular)
                }
                self.tableViewModelAry = pmModel
                break
            case 2:
                guard let trModel = self.topRatedModel else{
                   self.loadModel(withURL: MovieConst.urls.topRated)
                }
                self.tableViewModelAry = trModel
                break
            case 3:
                guard let ucModel = self.upcomingModel else{
                   self.loadModel(withURL: MovieConst.urls.upComing)
                }
                self.tableViewModelAry = ucModel
                break
            
            default:
                print("ERROR ==> CHECK: MovieTableViewManager.changeModel(_:) ")
            break
            
        }
        
        
    }
    
    func loadModel(withURL : URL)
    {
        
        self.downloader.download(url: withURL){
            url in
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieConst.config.cellReuseID)! as! MovieTableViewCell
        //get movie model & assign props to cell attrs
        let movieModel = self.tableViewModelAry![indexPath.row]
        movieCell.movieTitleLabel.text = movieModel.movieTitleText
        movieCell.movieOverviewLabel.text = movieModel.movieOverviewLabelText
        movieCell.posterPathImageView.image = UIImage(data: movieModel.posterPath.imageData!)
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //tableView prefecting delegate func
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths
        {
            //get movie model
            var movieModel = self.tableViewModelAry![indexPath.row]
            // if image data nil, retreive resource
            guard movieModel.posterPath.imageData == nil else{return}
            // if task nil, start task, else in DL progress
            guard movieModel.task == nil else{return}
            
            movieModel.task = self.downloader.download(url: movieModel.posterPath.url){
                tempUrlForResource in
                
                //remove task, changes DL status to in progress
                movieModel.task = nil
                
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                    //get data @ url, reload table @ current indexPath
                    if let url = tempUrlForResource, let data = try? Data(contentsOf: url)
                    {
//                        DispatchQueue.main.async {
                            movieModel.posterPath.imageData = data
                            tableView.reloadRows(at: [indexPath], with: .none)
//                        }
                        
                    }
//                }
                
  
            }
        }
    }
    
    
    
    

}
