//
//  UsersViewModel.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftUtilities

enum UserCellType {
    case User(user: User)
    case Loading
    case Error(error: Error)
}

//This class provides user data to the corresponding view controller
class UsersViewModel {
    //Tracks if loading from the server is taking place
    let isLoading: Driver<Bool>
    //Cells representing user, loading and errors
    let cells: Driver<[UserCellType]>
    
    init(refreshTriggers: Observable<Void>,
         dataProvider: DataProviding)
    {
        //Initialize an activity indicator to track loading state
        let activityIndicator = ActivityIndicator()
        
        //Refresh user data from the server every time the refresh is triggered
        let userCells = refreshTriggers
            .flatMapLatest {
                dataProvider
                    .GetUsers(numberOfUsers: Constants.NumberOfUsers)
                    .trackActivity(activityIndicator)
            }
            .map { (users) -> [UserCellType] in
                //Show user cells
                return users.map { .User(user: $0) }
            }
            //Show an error cell if there's an error
            .asDriver(onErrorRecover: { (error) -> Driver<[UserCellType]> in
                return Driver.just([UserCellType.Error(error: error)])
            })
            .startWith([])
        
        //Initialize the placeholder cells that show while loading
        let loadingCells: [UserCellType] = (0..<Constants.NumberOfLoadingCells).map { _ in .Loading }
        
        isLoading = activityIndicator
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .startWith(false)
        
        //Show the user cells or loading cells depending if its currently loading or not
        cells = isLoading
            .withLatestFrom(userCells) { ($0, $1) }
            .map { (isLoading, userCells) in
                if isLoading {
                    return loadingCells
                }
                else {
                    return userCells
                }
            }
    }
}

