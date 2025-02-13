//
//  AudioTrack.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import Foundation

struct AudioTrack: Codable {
    let id: String
    let name: String
    let previewUrl: String? // The audio preview URL
    let artists: [Artist]
    let album: Album
    

    struct Artist: Codable {
        let name: String
    }

    struct Album: Codable {
        let name: String
        let images: [SpotifyImage]
    }

    enum CodingKeys: String, CodingKey {
        case id, name, artists, album
        case previewUrl = "preview_url"
    }
}
