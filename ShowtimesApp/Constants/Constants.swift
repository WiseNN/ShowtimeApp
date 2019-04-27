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
    
    let nowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1"
    let popular = "https://api.themoviedb.org/3/movie/popular?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1"
    let topRated = "https://api.themoviedb.org/3/movie/top_rated?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1"
    let upComing = "https://api.themoviedb.org/3/movie/upcoming?api_key=3c4ac38bffb8736407109b911e227ec5&language=en-US&page=1"
    
}

//struct Notifications{
//    let UpdateModel = Notification.Name(rawValue: "UpdateModel")
//}

struct MovieConst{
   static let config = Config()
    static let urls = Urls()
//    static let notif = Notifications()
}
