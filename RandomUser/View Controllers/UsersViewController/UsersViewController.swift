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
    
    struct Layout {
        static let InteritemSpacing: CGFloat = 3
        static let LineSpacing: CGFloat = 3
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
                
                if let cell = cell as? UserCollectionViewCell
                {
                    cell.user = user
                }
                
                return cell
            case .Error(let error):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersViewControllerConstants.CellIdentifiers.Error, for: IndexPath(row: row, section: 0))
                
                if let cell = cell as? ErrorCollectionViewCell
                {
                    cell.error = error
                }
                
                return cell
            case .Loading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersViewControllerConstants.CellIdentifiers.Loading, for: IndexPath(row: row, section: 0))
                return cell
            }
        }
        .disposed(by: disposeBag)
        
        //Handle user selection
        collectionViewUsers.rx
            .modelSelected(UserCellType.self)
            .asDriver()
            .drive(onNext: { [weak self] (userCellType) in
                switch (userCellType) {
                case .User(let user):
                    self?.performSegue(withIdentifier: UsersViewControllerConstants.Segues.ShowUserDetails, sender: user)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        collectionViewUsers.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UsersViewControllerConstants.Segues.ShowUserDetails,
            let vc = segue.destination as? UserDetailViewController,
            let user = sender as? User {
                vc.user = user
            }
    }
}

extension UsersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.cellForItem(at: indexPath)
        
        switch cell {
        case is ErrorCollectionViewCell:
            return CGSize(width: collectionView.frame.width, height: 200)
        default:
            let cellWidth = (collectionView.frame.width-UsersViewControllerConstants.Layout.InteritemSpacing)/2
            return CGSize(width: cellWidth, height:  cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UsersViewControllerConstants.Layout.InteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UsersViewControllerConstants.Layout.LineSpacing
    }
}

