//
//  MovieListViewController.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

protocol MovieListViewControllerDelegate: AnyObject {
    func movieListViewController(_ controller:MovieListViewController, didSelectMovie movie: MovieListViewModel.Movie)
}

class MovieListViewController: UITableViewController {
    
    var viewModel = MovieListViewModel()
    
    weak var delegate: MovieListViewControllerDelegate?
    
    private var target: MovieListViewControllerDelegate? { return next(default: delegate) }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieCount
    }
    
    func movieIndex(for indexPath: IndexPath) -> Int {
        return indexPath.row
    }
    
    func indexPath(for movieIndex: Int) -> IndexPath {
        return IndexPath(row: movieIndex, section: 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath) as! MovieListViewCell
        
        viewModel.requestMovie(at: movieIndex(for: indexPath)) { (result) in
            if let movie = try? result.get() {
                cell.titleView.text = movie.title
                cell.overviewView.text = movie.overview
                cell.voteAverageView.text = movie.voteAverage
                cell.voteAverageView.textColor = movie.voteAverageColor
                cell.releaseDateView.text = movie.releaseDate
                
                movie.requestPoster { (result) in
                    cell.posterView.image = try? result.get()
                }
            }
            else
            {
                cell.textLabel?.text = "\(indexPath)"
                cell.detailTextLabel?.text = ":o("
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.requestMovie(at: movieIndex(for: indexPath)) { (result) in
            if let movie = try? result.get() {
                self.target?.movieListViewController(self, didSelectMovie: movie)
            }
        }
    }
}
