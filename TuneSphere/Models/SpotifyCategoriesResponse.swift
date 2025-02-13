//
//  SpotifyCategoriesResponse.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/5/25.
//

import Foundation

struct SpotifyCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let href: String
    let items: [CategoryItem]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct CategoryItem: Codable {
    let href: String
    let icons: [CategoryIcon]
    let id: String
    let name: String
}

struct CategoryIcon: Codable {
    let height: Int
    let url: String
    let width: Int
}
