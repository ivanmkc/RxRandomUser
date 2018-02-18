//
//  DataProviding.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import RxSwift

protocol DataProviding {
    func GetUsers(numberOfUsers: Int) -> Observable<[User]>
}
