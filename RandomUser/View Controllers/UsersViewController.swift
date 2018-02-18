//
//  UsersViewController.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState

struct UsersViewControllerConstants {
    struct CellIdentifiers {
        static let User = "user"
        static let Error = "error"
        static let Loading = "loading"
    }
    
    struct Segues {
        static let ShowUserDetails = "showUserDetails"
    }
}

class UsersViewController: UIViewController {
    
    @IBOutlet private weak var collectionViewUsers: UICollectionView!
    
    var dataProvider: DataProviding!
    var disposeBag = DisposeBag()
    lazy var viewModel: UsersViewModel = {
        let refreshTriggers = Observable.merge(
            self.rx.viewWillAppear.asTrigger(),
            self.collectionViewUsers.pullToRefreshTrigger)
        
        return UsersViewModel(refreshTriggers: refreshTriggers, dataProvider: dataProvider)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupRx()
    }
    
    private func setupRx() {
        //Hook up pull-to-refresh
        viewModel
            .isLoading
            .drive(onNext: { [weak self] (isLoading) in
                if (!isLoading) {
                    self?.collectionViewUsers.es.stopPullToRefresh()
                }
            })
            .disposed(by: disposeBag)
        
        //Hook up cells
        viewModel.cells.drive(collectionViewUsers.rx.items)
        { (collectionView, row, cellType: UserCellType) in
            switch (cellType) {
            case .User(let user):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersViewControllerConstants.CellIdentifiers.User, for: IndexPath(row: row, section: 0))
                
                return cell
            case .Error(let error):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersViewControllerConstants.CellIdentifiers.Error, for: IndexPath(row: row, section: 0))                
                
                return cell
            case .Loading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersViewControllerConstants.CellIdentifiers.Loading, for: IndexPath(row: row, section: 0))
                return cell
            }
            }
            .disposed(by: disposeBag)
    }
}
