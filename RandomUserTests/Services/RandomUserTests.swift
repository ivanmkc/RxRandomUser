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
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
