//
//  MovieListViewCell.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

class MovieListViewCell: UITableViewCell {

    @IBOutlet var posterView: UIImageView!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var overviewView: UILabel!
    @IBOutlet var voteAverageView: UILabel!
    @IBOutlet var releaseDateView: UILabel!
 
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.image = nil
        titleView.text = nil
        overviewView.text = nil
        voteAverageView.text = nil
        releaseDateView.text = nil
    }
}
