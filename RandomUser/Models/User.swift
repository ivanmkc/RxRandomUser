//
//  User.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper

//Represents a user as defined at RandomUser.me
//Note: For strict SOLID conformance, we should use a protocol like UserModeling
struct User {
    var name : Name
    var email : String
    var gender : UserGender
    var picture : Picture
    var phone : String
    var cell : String
    
    var fullName : String {
        get {
            return "\(name.title.capitalized). \(name.first.capitalized) \(name.last.capitalized)"
        }
    }
}

extension User: Mappable
{
    init(map : Mapper) throws {
        try gender = map.from("gender")
        try email = map.from("email")
        try name = map.from("name")
        try picture = map.from("picture")
        try phone = map.from("phone")
        try cell = map.from("cell")
    }
}

enum UserGender: String {
    case Male = "male"
    case Female = "female"
}

