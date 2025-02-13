//
//  SearchResponse.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/8/25.
//

import Foundation

struct SearchResponse: Codable {
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
