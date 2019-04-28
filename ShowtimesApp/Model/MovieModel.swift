//
//  MovieModel.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/27/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import Foundation


struct PosterPath {
    var imageData : Data?
    var url : URL!
}
struct MovieModel
{
    var posterPath : PosterPath! = PosterPath()
    var movieTitleText: String
    var movieOverviewLabelText : String
    var task : URLSessionTask?
}


//Codable structs
struct CodableMovieModel : Decodable {
    var title : String?
    var poster_path : String?
    var overview : String?
}



class Movies{
    
    enum MovieCategory: Int{ case nowPlaying = 0, popular, topRated, upcoming}
    
    
    private var nowPlayingMovieModel : [MovieModel]? = nil
    private var popularMoviesModel : [MovieModel]? = nil
    private var topRatedModel : [MovieModel]? = nil
    private var upcomingModel : [MovieModel]? = nil
    
    func getModel(forCategory: MovieCategory) -> [MovieModel]?
    {
        switch forCategory {
            case .nowPlaying: return  self.nowPlayingMovieModel
            case .popular   : return  self.popularMoviesModel
            case .topRated  : return  self.topRatedModel
            case .upcoming  : return  self.upcomingModel
        }
    }
    
    func setModel(forCategory: MovieCategory, withModel: [MovieModel])
    {
        let movieModel = getModel(forCategory: forCategory)
        guard movieModel == nil else{ print("Model has already been loaded");return}
        switch forCategory {
            case .nowPlaying: self.nowPlayingMovieModel = withModel
            case .popular   : self.popularMoviesModel = withModel
            case .topRated  : self.topRatedModel = withModel
            case .upcoming  : self.upcomingModel = withModel
        }
        print("successfully set model for category \(forCategory)")
        print("--- SET MODEL ---\n\(withModel)")
    }
    
    
    func getUrl(forCategory: MovieCategory) -> URL
    {
        switch forCategory {
            case .nowPlaying: return MovieConst.urls.nowPlaying
            case .popular   : return MovieConst.urls.popular
            case .topRated  : return MovieConst.urls.topRated
            case .upcoming  : return MovieConst.urls.upComing
        }
    }
    
    
    
}
