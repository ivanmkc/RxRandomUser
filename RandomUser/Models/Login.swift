//
//  Login.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper

struct Login {
    let username: String
    let password: String
}

extension Login: Mappable
{
    init(map: Mapper) throws {
        try username = map.from("username")
        try password = map.from("password")
    }
}
