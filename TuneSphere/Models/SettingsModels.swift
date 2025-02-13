//
//  SettingsModels.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/1/25.
//

import Foundation

struct Section{
    let title : String
    let options:[Option]
}

struct Option{
    let title : String
    let handler : ()->Void
    
}
