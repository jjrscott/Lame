//
//  MovieListViewCell.swift
//  Lame
//
//  Created by John Scott on 13/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

class MovieListViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        print("\(value(forKey: "indexPath") ?? "nil") \(#function)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc override func prepareForReuse() {
        print("\(value(forKey: "indexPath") ?? "nil") \(#function)")
    }

}
