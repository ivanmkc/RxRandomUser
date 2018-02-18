//
//  Picture.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper

struct Picture {
    let large: URL
    let medium: URL
    let thumbnail: URL
}

extension Picture: Mappable
{
    init(map: Mapper) throws {
        try large = map.from("large", transformation: ModelMapperTransformations.extractURLFromString)
        try medium = map.from("medium", transformation: ModelMapperTransformations.extractURLFromString)
        try thumbnail = map.from("thumbnail", transformation: ModelMapperTransformations.extractURLFromString)
    }
}
