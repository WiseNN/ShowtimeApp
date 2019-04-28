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
    var movies = Movies()
    var tableViewModelAry : [MovieModel] = [MovieModel]()
        //set present tab
    var presentTabTag : Int! {
        didSet{
            
            let movieCategory = Movies.MovieCategory(rawValue: presentTabTag)!
            let movieModelAry = movies.getModel(forCategory: movieCategory)
            
            //if nil, load model else use in memory model
            guard movieModelAry == nil else{
                tableViewModelAry = movieModelAry!
                NotificationCenter.default.post(name: MovieConst.notifications.refreshTable, object: nil)
                return
            }
            let categoryUrl = movies.getUrl(forCategory: movieCategory)
            loadModel(atURL: categoryUrl, forCategory: movieCategory)
            
        }
    }
    
    

        //instantiate downloader
    let downloader : Downloader =  {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        return Downloader(configuration: config)
    }()
    
    
    

    
    func loadModel(atURL : URL, forCategory: Movies.MovieCategory)
    {
        self.downloader.download(url: atURL){
            resourceTempUrl in
            
            do{
                let data = try Data(contentsOf: resourceTempUrl!)
                //deserialize json and map to codable movie model ary
                let codableMovieResults = try JSONDecoder().decode(CodableResults.self, from: data)
                let cMmAry = codableMovieResults.results!
                print("Data Model from API: \(cMmAry)")
                var movieModelAry = [MovieModel]()

                for cMm in cMmAry
                {
                    let imageUrl : URL? = cMm.poster_path != nil ? MovieConst.urls.baseImage.appendingPathComponent(cMm.poster_path!) : nil
                    let newMovieModel = MovieModel(posterPath: PosterPath(imageData: nil, url: imageUrl), movieTitleText: cMm.title!, movieOverviewLabelText: cMm.overview!, task: nil)
                    
                    
                   movieModelAry.append(newMovieModel)
                }
                print("")
                
                self.movies.setModel(forCategory: forCategory, withModel: movieModelAry)
                let retrievedModel = self.movies.getModel(forCategory: forCategory)
                guard let updatedMovieModel = retrievedModel else{ print("ATTN!! => \(forCategory) movie model is empty");return}
                self.tableViewModelAry = updatedMovieModel
                NotificationCenter.default.post(name: MovieConst.notifications.refreshTable, object: nil)
                
                
                
            }catch {
                print("ATTN!! => Model loading err: \(error.localizedDescription)")
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModelAry.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieConst.config.cellReuseID)! as! MovieTableViewCell
        
        if movieCell.tag != 232
        {
            movieCell.tag == 232
            movieCell.posterPathImageView.contentMode = .scaleAspectFill
            movieCell.posterPathImageView.clipsToBounds = true
            movieCell.contentView.layer.backgroundColor = UIColor.black.cgColor
            movieCell.movieTitleLabel.textColor = UIColor.white
            movieCell.movieOverviewLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
            movieCell.selectionStyle = .none
            
            
        }
        //get movie model & assign props to cell attrs
        guard tableViewModelAry.count > 0 else{return movieCell}
        let movieModel = self.tableViewModelAry[indexPath.row]
        movieCell.movieTitleLabel.text = movieModel.movieTitleText
        movieCell.movieOverviewLabel.text = movieModel.movieOverviewLabelText
        if let imageData = movieModel.posterPath.imageData
        {
            DispatchQueue.main.async {
                let img = UIImage(data: imageData)
                movieCell.viewWithTag(122)?.removeFromSuperview()
                movieCell.posterPathImageView.image = img
                
            }
            
        }else{
            movieCell.posterPathImageView.image = nil
            let uiActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            uiActivityIndicator.frame = movieCell.posterPathImageView.bounds
            uiActivityIndicator.tag = 122
            movieCell.addSubview(uiActivityIndicator)
            uiActivityIndicator.startAnimating()
            
        }
        
        
        if movieModel.task == nil && movieModel.posterPath.imageData == nil
        {
            guard tableView.indexPathsForVisibleRows != nil else{return movieCell}
            self.tableView(tableView, prefetchRowsAt: tableView.indexPathsForVisibleRows!)
        }
        return movieCell
    }
    
    
    
    func imageDownloadHelper(forTableView : UITableView, withRowIndex : Int)
  {
    
    //get movie model
    var movieModel = self.tableViewModelAry[withRowIndex]
    // if image data nil, retreive resource
    guard movieModel.posterPath.imageData == nil else{return}
    // if task nil, start task, else in DL progress
    guard movieModel.task == nil && movieModel.posterPath.url != nil else{return}
    
    self.tableViewModelAry[withRowIndex].task = self.downloader.download(url: movieModel.posterPath.url){
        tempUrlForResource in
        
        //remove task, changes DL status to in progress
        self.tableViewModelAry[withRowIndex].task = nil
        
        //get data @ url, reload table @ current indexPath
        if let url = tempUrlForResource, let data = try? Data(contentsOf: url)
        {
            self.tableViewModelAry[withRowIndex].posterPath.imageData = data
            let currentIndexPath = IndexPath(item: withRowIndex, section: 0)
            guard forTableView.indexPathsForVisibleRows!.contains(currentIndexPath) else{return}
            forTableView.reloadRows(at: [currentIndexPath], with: .fade)
        }
    }
  }
    
    //tableView prefecting delegate func
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard tableViewModelAry.count > 0 else{return}
        indexPaths.forEach{self.imageDownloadHelper(forTableView: tableView, withRowIndex: $0.row)}
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieCell = tableView.visibleCells[indexPath.row] as! MovieTableViewCell
        
        movieCell.startOverviewScrollAnimation()
        print("selected cell \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let movieCell = tableView.visibleCells[indexPath.row] as! MovieTableViewCell
        movieCell.stopOverviewScrollingAnimation()
        
        
    }
    
    
    

}
