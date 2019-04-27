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
