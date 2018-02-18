//
//  Picture.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper

struct Picture {
    let large : String
    let medium : String
    let thumbnail : String
}

extension Picture: Mappable
{
    init(map : Mapper) throws {
        try large = map.from("large")
        try medium = map.from("medium")
        try thumbnail = map.from("thumbnail")
    }
}
