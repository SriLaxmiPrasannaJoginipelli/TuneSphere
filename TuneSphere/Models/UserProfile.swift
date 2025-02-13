//
//  UserProfile.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/1/25.
//

import Foundation

import Foundation

struct UserProfile: Codable {
    let display_name: String
    let explicit_content: ExplicitContent
    let external_urls: [String: String]
    let followers: Followers
    let id: String
    let product: String
    let images: [APIImage]
    let country: String
}

struct ExplicitContent: Codable {
    let filter_enabled: Bool
    let filter_locked: Bool
}

struct Followers: Codable {
    let href: String?
    let total: Int
}




