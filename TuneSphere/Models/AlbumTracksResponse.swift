//
//  AlbumTracksResponse.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/12/25.
//

import Foundation

struct AlbumTracksResponse: Codable {
    let items: [Track]
}

//struct Track: Codable {
//    let id: String
//    let name: String
//    let preview_url: String? 
//}

struct Track: Codable {
    let id: String
    let name: String
    let uri: String 
}

