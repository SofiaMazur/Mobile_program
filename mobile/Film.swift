//
//  Film.swift
//  Laba
//
//  Created by razur on 03.06.2021.
//

import Foundation

struct Films: Decodable {
    var results = [Film]()
}

struct Film: Decodable {
    var id: Int
    var poster_path: String
    var title: String
}
