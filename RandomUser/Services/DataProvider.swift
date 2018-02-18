//
//  DataProvider.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import RxSwift
import Result
import Moya

class DataProvider: DataProviding {
    private let provider: MoyaProvider<RandomUserTarget>
    
    init(provider: MoyaProvider<RandomUserTarget>) {
        self.provider = provider
    }
    
    func GetUsers(numberOfUsers: Int) -> Observable<[User]> {
        return provider.loadArray(.GetRandomUsers(numberOfUsers: numberOfUsers))
    }
}
