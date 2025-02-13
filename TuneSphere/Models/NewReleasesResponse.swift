//
//  NewReleasesResponse.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/4/25.
//

import Foundation

struct NewReleasesResponse : Codable{
    let albums : AlbumsResponse
}

struct AlbumsResponse : Codable{
    let items : [Albums]
}

struct Albums : Codable{
    let album_type : String
    let available_markets : [String]
    let id : String
    let images : [APIImage]
    let name : String
    let release_date : String
    let total_tracks : Int
    let artists : [Artist]
}


