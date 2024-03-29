//
//  ViewModel.swift
//  Balina
//
//  Created by Roman on 9/25/23.
//

import Foundation

struct ContentViewModel {
    let id: Int
    let name: String
    let imageURLString: String?
    
    init(id: Int, name: String, imageURLString: String?) {
        self.id = id
        self.name = name
        self.imageURLString = imageURLString
    }
}
