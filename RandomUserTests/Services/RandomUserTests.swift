//
//  RandomUserTests.swift
//  RandomUserTests
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RandomUser

class DataProviderTests: XCTestCase {
    
    private let TIMEOUT_IN_SECONDS : TimeInterval = 10
    private var dataProvider: DataProviding!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataProvider = DataProvider()
    }
    
    func testGetUsers() {
        do {
            guard let users = try dataProvider.GetUsers(numberOfUsers: 100)
                .toBlocking(timeout: TIMEOUT_IN_SECONDS)
                .first() else {
                    XCTFail("No users found.")
                    return
            }
            
            XCTAssertEqual(users.count, 100)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
