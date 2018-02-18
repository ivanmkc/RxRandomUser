//
//  DataProvider.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import RxSwift

class DataProvider: DataProviding {
    func GetUsers(numberOfUsers: Int) -> Observable<[User]> {
        return Observable.just([])
    }
}
