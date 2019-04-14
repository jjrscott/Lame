//
//  MovieListViewModel.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import Foundation
import UIKit.UIImage
import UIKit.UIColor

class MovieListViewModel {
    
    enum ModalError: Error {
        case noPosterPath
        case corruptImage
    }
    
    struct Movie {
        let trendingResult: TheMovieDatabase.TrendingResult
        var title: String { return trendingResult.title}
        var overview: String { return trendingResult.overview}
        var voteAverage: String {
            if trendingResult.voteAverage == 0 {
                return "—"
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .percent
            
            return numberFormatter.string(for: NSNumber(floatLiteral: trendingResult.voteAverage / 10)) ?? ""
        }
        var voteAverageColor: UIColor {
            if trendingResult.voteAverage >= 7 {
                return UIColor(named: "VoteAverageHigh")!
            } else if trendingResult.voteAverage >= 4 {
                return UIColor(named: "VoteAverageMedium")!
            } else if trendingResult.voteAverage > 0 {
                return UIColor(named: "VoteAverageLow")!
            } else {
                return UIColor.darkGray
            }
        }
        var releaseDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            return dateFormatter.string(from: trendingResult.releaseDate)}
        weak var viewModel: MovieListViewModel?
        
        func requestPoster(result: @escaping (Result<UIImage,Error>)->Void) {
            viewModel?.requestPoster(for: self, result: result)
        }
    }
    
    private let client = TheMovieDatabase()
    
    private(set) var movieCount: Int = 100000
    
    var movieRequests: [Int: (Result<Movie,Error>)->Void] = [:]
    
    private let queue = DispatchQueue(label: "MovieListViewModel")
    
    private var cachedMovies: [Movie] = []
    
    var resultQueue: DispatchQueue = DispatchQueue.main
    
    func notifyWithMovie(at index: Int) {
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
            
            if let posterPath = self.cachedMovies[safe: index]?.trendingResult.posterPath {
                self.imageRequests[posterPath] = nil
            }
        }
    }
    
    private var isRequestingPages: Bool = false
    private var nextTrendingPageToRequest = 1

    private func requestPagesIfNeeded() {
        if isRequestingPages { return }
        
        if let maxRequestedIndex = movieRequests.keys.max(), maxRequestedIndex < self.cachedMovies.count {
            return
            
        }
        
        isRequestingPages = true
        
        client.requestTrending(page: nextTrendingPageToRequest) { (result) in
            
            if let trendingResults = try? result.get() {
                self.queue.sync { [unowned self] in
                    for trendingResult in trendingResults {
                        let index = self.cachedMovies.count
                        self.cachedMovies.append(Movie(trendingResult: trendingResult, viewModel: self))
                        self.notifyWithMovie(at: index)
                    }
                    self.nextTrendingPageToRequest += 1
                    self.isRequestingPages = false
                    self.requestPagesIfNeeded()
                }
                
            } else {
            }
        }
    }
    
    private var imageRequests: [String: (Result<UIImage,Error>)->Void] = [:]
    private var cachedImages: [String:UIImage] = [:]
    
    private func requestPoster(for movie: Movie, result: @escaping (Result<UIImage,Error>)->Void) {
        queue.async { [unowned self] in
            if let posterPath = movie.trendingResult.posterPath {
                self.imageRequests[posterPath] = result
                if let image = self.cachedImages[posterPath] {
                    self.resultQueue.async { self.imageRequests[posterPath]?(.success(image)) }
                } else {
                    self.client.requestPoster(path: posterPath) { (clientResult) in
                        clientResult.pipe(to: result) { (data, result) in
                            if let image = UIImage(data: data) {
                                self.queue.sync {
                                    self.cachedImages[posterPath] = image
                                }
                                self.resultQueue.async { self.imageRequests[posterPath]?(.success(image)) }
                            } else {
                                self.resultQueue.async { self.imageRequests[posterPath]?(.failure(ModalError.corruptImage)) }
                            }
                        }
                    }
                }
            } else {
                self.resultQueue.async { result(.failure(ModalError.noPosterPath)) }
            }
        }
    }
}
