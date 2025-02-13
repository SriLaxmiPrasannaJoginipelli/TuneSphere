//
//  CategoryDetailsResponse.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/6/25.
//

import Foundation

struct CategoryDetailsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let href: String
    let items: [Playlist?]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}


struct Playlist: Codable {
    let id: String
    let name: String
    let description: String?
    let externalUrls: ExternalURL
    let images: [SpotifyImage]?
    let owner: PlaylistOwner
    let tracks: PlaylistTracks

    enum CodingKeys: String, CodingKey {
        case id, name, description, images, owner, tracks
        case externalUrls = "external_urls"
    }
}

struct ExternalURL: Codable {
    let spotify: String
}

struct SpotifyImage: Codable {
    let url: String
}

struct PlaylistOwner: Codable {
    let displayName: String
    let externalUrls: ExternalURL
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}

struct PlaylistTracks: Codable {
    let href: String
    let total: Int
}
