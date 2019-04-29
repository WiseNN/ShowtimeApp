//
//  Constants.swift
//  ShowtimesApp
//
//  Created by Norris Wise Jr on 4/27/19.
//  Copyright © 2019 Norris Wise Jr. All rights reserved.
//

import UIKit


struct Config{
    let cellReuseID = "movieCell"
    let nibName = "MovieTableViewCell"
    
}

struct Urls{
    
    let nowPlaying = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1")!
    let popular = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1")!
    let topRated = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1")!
    let upComing = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1")!
    let baseImage = URL(string: "https://image.tmdb.org/t/p/w185/")!
    
}

struct Notifications{
    let refreshTable = Notification.Name(rawValue: "RefreshTable")
}


struct Tags {
    let parentViewCellTag = 543
    let movieCellTag = 232
    let uiActivityIndicatorTag = 122
    let movieTableViewTag = 432
    let copyLabelForAnim = 112
}

struct MovieConst{
   static let config = Config()
    static let urls = Urls()
    static let notifications = Notifications()
    static let tags = Tags()
    
}

