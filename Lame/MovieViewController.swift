//
//  MovieViewController.swift
//  Lame
//
//  Created by John Scott on 12/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet var posterView: UIImageView!
    
    var movie: MovieListViewModel.Movie? {
        didSet {
            movie?.requestPoster { (result) in
                self.posterView.image = try? result.get()
            }
            self.title = movie?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
