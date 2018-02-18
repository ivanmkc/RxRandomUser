//
//  UserTests.swift
//  RandomUserTests
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

@testable import RandomUser

import XCTest
import SwiftDate

class UserTests: XCTestCase {    
    func testUserAge() {
        let dateOfBirth = DateInRegion(components: [.year: 1912, .month: 6, .day: 23, .hour: 0, .minute: 0, .second: 0])!.absoluteDate
        let referenceDate = DateInRegion(components: [.year: 1933, .month: 6, .day: 24, .hour: 0, .minute: 0, .second: 0])!.absoluteDate
        let referenceDate2 = DateInRegion(components: [.year: 1933, .month: 6, .day: 22, .hour: 0, .minute: 0, .second: 0])!.absoluteDate
        
        let name = Name(title: "Mr", first: "", last: "")
        let login = Login(username: "", password: "")
        let location = Location(street: "", city: "", state: "")
        let user = User(name: name, email: "", gender: .Male, picture: nil, login: login, location: location, phone: "", cell: "", dateOfBirth: dateOfBirth)
        let age = user.GetAge(referenceDate: referenceDate)
        let age2 = user.GetAge(referenceDate: referenceDate2)
        
        XCTAssertEqual(age, 21)
        XCTAssertEqual(age2, 20)
    }
}
