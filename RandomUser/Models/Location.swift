//
//  Location.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper

struct Location {
    let street: String
    let city: String
    let state: String
}

extension Location: Mappable
{
    init(map: Mapper) throws {
        try street = map.from("street")
        try city = map.from("city")
        try state = map.from("state")
    }
}


