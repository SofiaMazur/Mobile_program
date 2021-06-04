//
//  Recipe.swift
//  Laba
//
//  Created by razur on 03.06.2021.
//

import Foundation

struct Recipes: Decodable {
    var number: Int
    var results = [Recipe]()
}

struct Recipe: Decodable {
    var id: Int
    var image: String
    var title: String
}

struct RecipeItem: Decodable {
    var summary: String
    var instructions: String
}
