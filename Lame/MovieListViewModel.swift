//
//  MovieListViewModel.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct MovieListViewModel {
    
    enum ModalError: Error {
        case noPosterPath
        case corruptImage
    }
    
    struct Movie {
        let movie: TheMovieDatabase.TrendingResult
    }
    
    private let client = TheMovieDatabase()
    
    private(set) var movieCount: Int = 100000
    
    var requests: [Int: (Result<Movie,Error>)->Void] = [:]
    
    func requestMovie(at index: Int, result: (Result<Movie,Error>)->Void) {
        
    }
    
    func unrequestMovie(at index: Int) {
        
    }
    
    func requestPoster(for movie: Movie, result: @escaping (Result<UIImage,Error>)->Void) {
        if let postPath = movie.movie.posterPath {
            client.requestPoster(path: postPath) { (clientResult) in
                clientResult.pipe(to: result) { (data, result) in
                    if let image = UIImage(data: data) {
                        result(.success(image))
                    } else {
                        result(.failure(ModalError.corruptImage))
                    }
                }
            }
        } else {
            result(.failure(ModalError.noPosterPath))
        }
    }
}

