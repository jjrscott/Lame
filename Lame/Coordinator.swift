//
//  Coordinator.swift
//  Lame
//
//  Created by John Scott on 12/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

@UIApplicationMain
class Coordinator: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
}

extension Coordinator: MovieListViewControllerDelegate {
    func movieListViewController(_ controller: MovieListViewController, didSelectMovie movie: MovieListViewModel.Movie) {
        controller.performSegue(withIdentifier: MainSequeShowMovie) { (movieViewController: MovieViewController) in
            movieViewController.movie = movie
        }
    }
}
