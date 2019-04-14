//
//  MovieListViewModel.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import Foundation
import UIKit.UIImage

class MovieListViewModel {
    
    enum ModalError: Error {
        case noPosterPath
        case corruptImage
    }
    
    struct Movie {
        let trendingResult: TheMovieDatabase.TrendingResult
        var title: String { return trendingResult.title}
        var overview: String { return trendingResult.overview}

    }
    
    private let client = TheMovieDatabase()
    
    private(set) var movieCount: Int = 100000
    
    var movieRequests: [Int: (Result<Movie,Error>)->Void] = [:]
    
    private let queue = DispatchQueue(label: "MovieListViewModel")
    
    private var cacheImages: [Int:UIImage] = [:]
    private var cachedMovies: [Movie] = []
    
    var resultQueue: DispatchQueue = DispatchQueue.main
    
    func notifyWithMovie(at index: Int) {
        print("\(#function) \(index)")

        queue.async { [unowned self] in
            guard let result = self.movieRequests[index], let movie = self.cachedMovies[safe: index] else { return }
            self.resultQueue.async {
                result(.success(movie))
            }
        }
    }
    
    func requestMovie(at index: Int, result: @escaping (Result<Movie,Error>)->Void) {
        queue.async { [unowned self] in
            self.movieRequests[index] = result
            self.notifyWithMovie(at: index)
            self.requestPagesIfNeeded()
        }
    }
    
    func unrequestMovie(at index: Int) {
        queue.async { [unowned self] in
            self.movieRequests[index] = nil
        }
    }
    
    private var isRequestingPages: Bool = false
    private var nextTrendingPageToRequest = 1

    private func requestPagesIfNeeded() {
        if isRequestingPages { return }
        
        print("requestTrending > \(nextTrendingPageToRequest)")
        if let maxRequestedIndex = movieRequests.keys.max(), maxRequestedIndex < self.cachedMovies.count {
            print("requestTrending < \(nextTrendingPageToRequest) \(maxRequestedIndex) <=> \(self.cachedMovies.count)")
            return
            
        }
        
        isRequestingPages = true
        
        client.requestTrending(page: nextTrendingPageToRequest) { (result) in
            
            if let trendingResults = try? result.get() {
                self.queue.sync { [unowned self] in
                    for trendingResult in trendingResults {
                        let index = self.cachedMovies.count
                        self.cachedMovies.append(Movie(trendingResult: trendingResult))
                        self.notifyWithMovie(at: index)
                    }
                    print("requestTrending < \(self.nextTrendingPageToRequest)")
                    self.nextTrendingPageToRequest += 1
                    self.isRequestingPages = false
                    self.requestPagesIfNeeded()
                }
                
            } else {
                
                
                
            }
            
            
        }
        
    }
    
    func requestPoster(for movie: Movie, result: @escaping (Result<UIImage,Error>)->Void) {
        if let postPath = movie.trendingResult.posterPath {
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

