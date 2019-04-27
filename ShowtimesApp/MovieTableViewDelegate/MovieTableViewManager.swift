//
//  MovieTableViewDelegate.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/27/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import UIKit

class MovieTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource
{
    //data model vars
    var nowPlayingDictionary : [String : MovieModel]?
    var popularMoviesDictionary : [String : MovieModel]?
    var topRatedDictionary : [String : MovieModel]?
    var upcomingDictionary : [String : MovieModel]?
    var tableViewModel : [String : MovieModel]?
    
    
    
    func changeModel(forTag : Int)
    {
        switch forTag
        {
            case 1:
                guard let npDict = nowPlayingDictionary else{
                    
                    return}
                tableViewModel = npDict
                break
            case 2:
                guard let popMovieDict = popularMoviesDictionary else{return}
                tableViewModel = popMovieDict
                break
            case 3:
                guard let topRatedDict = topRatedDictionary else{return}
                tableViewModel = topRatedDict
                break
            case 4:
                guard let upComingDict = upcomingDictionary else{return}
                tableViewModel = upComingDict
                break
            
            default:
                print("ERROR ==> CHECK: MovieTableViewManager.changeModel(_:) ")
            break
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieConst.config.cellReuseID)!
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    

}
