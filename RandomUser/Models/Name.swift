//
//  UserName.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper

struct Name {
    let title: String
    let first: String
    let last: String
}

extension Name: Mappable
{
    init(map: Mapper) throws {
        try first = map.from("first")
        try last = map.from("last")
        try title = map.from("title")
    }
}

