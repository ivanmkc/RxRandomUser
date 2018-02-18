//
//  Observable+extensions.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import RxSwift
import RxCocoa

extension Observable {
    func asTrigger() -> Observable<Void>
    {
        return self.map
            { (_) -> Void in
                return
        }
    }
    
    func asDriverSkippingErrors() -> Driver<E>
    {
        return self.asDriver { (_) -> Driver<E> in
            return Driver.never()
        }
    }
}
