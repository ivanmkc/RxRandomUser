//
//  RandomUserTests.swift
//  RandomUserTests
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

@testable import RandomUser

import XCTest
import RxSwift
import RxBlocking
import Moya

class DataProviderTests: XCTestCase {    
    private var dataProvider: DataProviding!
    
    override func setUp() {
        super.setUp()
        
        let mockProvider = MoyaProvider<RandomUserTarget>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [RandomUserResponsePlugin()])
        
        dataProvider = DataProvider(provider: mockProvider)
    }
    
    func testGetUsers() {
        do {
            guard let users = try dataProvider.GetUsers(numberOfUsers: TestConstants.numberOfUsersInStub)
                .toBlocking(timeout: TestConstants.timeoutInSeconds)
                .first() else {
                    XCTFail("No users found.")
                    return
            }
            
            XCTAssertEqual(users.count, TestConstants.numberOfUsersInStub)
            
            
            //Check content of first user cell
            if let user = users.first {
                XCTAssertEqual(user.name.first, "ege", "Incorrect first name of first user")
                XCTAssertEqual(user.name.last, "alpuğan", "Incorrect last name of first user")
                XCTAssertEqual(user.email, "ege.alpuğan@example.com", "Incorrect email of first user")
                XCTAssertEqual(user.gender, .Female, "Incorrect gender of first user")
                XCTAssertEqual(user.login.username, "silverladybug155", "Incorrect username of first user")
            }
            else {
                XCTFail("First user not found")
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
