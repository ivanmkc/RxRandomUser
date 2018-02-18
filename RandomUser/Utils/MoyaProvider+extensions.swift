//
//  MoyaProvider+extensions.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import RxSwift
import Moya
import Moya_ModelMapper
import Mapper

extension MoyaProvider
{
    func load<T: Mappable>(_ target: Target) -> Observable<T> {
        return self
            .rx
            .request(target)
            .map(to: T.self)
            .asObservable()
    }
    
    func loadArray<T: Mappable>(_ target: Target) -> Observable<[T]> {
        return self
            .rx
            .request(target)
            .map(to: [T].self)
            .asObservable()
    }
}
