//
//  UIScrollView+extensions.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import UIKit
import RxSwift
import ESPullToRefresh

extension UIScrollView {
    var pullToRefreshTrigger: Observable<Void> {
        //Note: This recreates the obsevable every time it's called.
        return Observable.create { (observer) -> Disposable in
            //Add pull-to-refresh
            self.es.addPullToRefresh {
                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
}
