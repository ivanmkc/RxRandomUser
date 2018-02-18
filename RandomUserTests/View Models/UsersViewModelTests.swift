//
//  UsersViewModelTests.swift
//  RandomUserTests
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

@testable import RandomUser

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import Moya

class UsersViewModelTests: XCTestCase {
    
    private var provider: DataProviding!
    
    override func setUp() {
        super.setUp()
        
        let mockProvider = MoyaProvider<RandomUserTarget>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [RandomUserResponsePlugin()]
        )
        
        provider = DataProvider(provider: mockProvider)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserViewModelCells() {
        let refreshTrigger = Observable.just(())
        let userViewModel = UsersViewModel(refreshTriggers: refreshTrigger, dataProvider: provider)
        
        do {
            //Get the first three cell collections emitted by the observable
            let cellElements = try userViewModel.cells
                .asObservable()
                .take(4)
                .toBlocking(timeout: TestConstants.timeoutInSeconds)
                .toArray()
            
            //Check initial value for cells
            let initialCells = cellElements[0]
            XCTAssertEqual(initialCells.count, 0, "Incorrect number of initial cells")
            
            //Check value for 'Loading' cells
            let loadingCells = cellElements[1]
            XCTAssertEqual(loadingCells.count, Constants.NumberOfLoadingCells, "Incorrect number of loading cells")
            let areAllCellsLoadingCells = loadingCells
                .map { (cell) -> Bool in
                    switch cell {
                    case .Loading:
                        return true
                    default:
                        return false
                    }
                }
                .reduce(true, { $0 && $1 })
            XCTAssert(areAllCellsLoadingCells, "Incorrect types of initial loading cells")
            
            //Skip the repeat of the loading cells
            
            //Check triggered value for 'User' cells
            let userCells = cellElements[3]
            XCTAssertEqual(userCells.count, TestConstants.numberOfUsersInStub, "Incorrect number of user cells")
            
            let areAllCellsUserCells = userCells
                .map { (cell) -> Bool in
                    switch cell {
                    case .User:
                        return true
                    default:
                        return false
                    }
                }
                .reduce(true, { $0 && $1 })
            
            XCTAssert(areAllCellsUserCells, "Incorrect types of user cells")
            
            //Check content of first user cell
            if let firstUserCell = userCells.first {
                switch (firstUserCell) {
                case .User(let user):
                    XCTAssertEqual(user.name.first, "ege", "Incorrect first name of first user")
                    XCTAssertEqual(user.name.last, "alpuğan", "Incorrect last name of first user")
                    XCTAssertEqual(user.email, "ege.alpuğan@example.com", "Incorrect email of first user")
                    XCTAssertEqual(user.gender, .Female, "Incorrect gender of first user")
                default:
                    XCTFail("Incorrect type for first user")
                }
            }
            else {
                XCTFail("First user not found")
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testUserViewModelErrorCells() {
        //Initialize a mock provider that always returns an error
        let mockProvider = MoyaProvider<RandomUserTarget>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [MockErrorPlugin(mockError: RandomUserResponseError.InvalidResponseFormat)]
        )
        
        //Initialize the data provider
        let errorProvider = DataProvider(provider: mockProvider)
        
        let refreshTrigger = Observable.just(())
        let userViewModel = UsersViewModel(refreshTriggers: refreshTrigger, dataProvider: errorProvider)
        
        do {
            //Get the first three cell collections emitted by the observable
            let cellElements = try userViewModel.cells
                .asObservable()
                .take(4)
                .toBlocking(timeout: TestConstants.timeoutInSeconds)
                .toArray()
            
            //Check triggered value for 'User' cells
            let errorCells = cellElements[3]
            XCTAssertEqual(errorCells.count, 1, "Incorrect number of error cells")

            let areAllCellsErrorCells = errorCells
                .map { (cell) -> Bool in
                    switch cell {
                    case .Error:
                        return true
                    default:
                        return false
                    }
                }
                .reduce(true, { $0 && $1 })

            XCTAssert(areAllCellsErrorCells, "Incorrect types of error cells")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}


