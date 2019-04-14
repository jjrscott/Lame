//
//  Collection+Safe.swift
//  Lame
//
//  Created by Penkey Suresh on 14/05/2016.
//  https://stackoverflow.com/a/37225027/542244
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
