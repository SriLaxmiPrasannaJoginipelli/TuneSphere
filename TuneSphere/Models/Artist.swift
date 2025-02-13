//
//  Artist.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import Foundation

struct Artist : Codable{
    let id : String
    let name : String
    let type : String
    let external_urls : [String : String]
    
}
