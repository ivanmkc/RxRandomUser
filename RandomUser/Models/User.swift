//
//  User.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper
import SwiftDate

//Represents a user as defined at RandomUser.me
//Note: For strict SOLID conformance, we should use a protocol like UserModeling
struct User {
    var name: Name
    var email: String
    var gender: UserGender
    var picture: Picture?
    var login: Login
    var location: Location
    var phone: String
    var cell: String
    var dateOfBirth: Date
    
    var fullName: String {
        return "\(name.title.capitalized). \(name.first.capitalized) \(name.last.capitalized)"
    }
    
    func GetAge(referenceDate: Date = Date()) -> Int {
        return max((referenceDate.timeIntervalSince(dateOfBirth)).in(.year) ?? 0, 0)
    }
}

extension User: Mappable
{
    init(map: Mapper) throws {
        try gender = map.from("gender")
        try email = map.from("email")
        try name = map.from("name")
        picture = map.optionalFrom("picture")
        try phone = map.from("phone")
        try cell = map.from("cell")
        try login = map.from("login")
        try location = map.from("location")
        try dateOfBirth = map.from("dob", transformation: ModelMapperTransformations.extractDateFromRandomUserDateString)
    }
}

enum UserGender: String {
    case Male = "male"
    case Female = "female"
}

