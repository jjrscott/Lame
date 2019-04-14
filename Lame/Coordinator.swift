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
        controller.performSegue(withIdentifier: "ShowMovie") { (viewController) in
            guard let viewController = viewController as? MovieViewController else { fatalError() }
            viewController.movie = movie
        }
    }
}
