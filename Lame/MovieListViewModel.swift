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
    
    struct Movie {
        
    }
    
    private(set) var movieCount: Int = 100000
    
    func requestMovie(at index: Int, result: (Result<Movie,Error>)->Void) {
        
    }
    
    func unrequestMovie(at index: Int) {
        
    }
}
