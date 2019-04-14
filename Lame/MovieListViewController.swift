//
//  MovieListViewController.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

protocol MovieListViewControllerDelegate: AnyObject {
    func selectMovie(_ movie: MovieListViewModel.Movie)
}

class MovieListViewController: UITableViewController {
    
    var viewModel = MovieListViewModel()
    
    weak var delegate: MovieListViewControllerDelegate?
    
    private var target: MovieListViewControllerDelegate? { return target(default: delegate) }
    
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
        return tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.requestMovie(at: movieIndex(for: indexPath)) { (result) in
            if let movie = try? result.get() {
                cell.textLabel?.text = movie.title
                cell.detailTextLabel?.text = movie.overview
            }
            else
            {
                cell.textLabel?.text = "\(indexPath)"
                cell.detailTextLabel?.text = ":o("
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.requestMovie(at: movieIndex(for: indexPath)) { (result) in
            if let movie = try? result.get() {
                self.target?.selectMovie(movie)
            }
        }
    }
}
