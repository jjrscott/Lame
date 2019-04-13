//
//  TheMovieDatabase.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import Foundation

class TheMovieDatabase {
    
    enum Error: Swift.Error {
        case noResponse
        case badResponse(URLResponse)
        case badStatusCode(HTTPURLResponse)
        case noData(HTTPURLResponse)
    }
    
    private let apiKey = "3a330fc36a2b951b7320b3badba67d90"
    
    private let trendingUrlPrefix = "https://api.themoviedb.org/3/trending/movie/week"
    
    struct TrendingResult: Decodable {
        let posterPath: String?
        let overview: String
        let title: String
        let popularity: Double
        let releaseDate: String
    }
    
    struct TrendingResponse: Decodable {
        let page: Int
        let totalPages: Int
        let totalResults: Int
        let results: [TrendingResult]
    }
    
    func requestTrending(page pageIndex: UInt = 1, result: @escaping (Result<[TrendingResult],Swift.Error>)->Void) {
        
        guard let url = URL(string: "\(trendingUrlPrefix)?api_key=\(apiKey)&page=\(pageIndex)") else { fatalError() }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response else {
                result(.failure(Error.noResponse))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(Error.badResponse(response)))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                result(.failure(Error.badStatusCode(httpResponse)))
                return
            }
            
            guard let data = data else {
                result(.failure(Error.noData(httpResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let trendingResponse = try decoder.decode(TrendingResponse.self, from: data)
                
                result(.success(trendingResponse.results))
            } catch let error {
                result(.failure(error))
                return
            }
            
        }
        task.resume()
    }
    
    
}
