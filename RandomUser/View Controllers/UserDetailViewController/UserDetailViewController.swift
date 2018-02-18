//
//  UserDetailViewController.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

struct UserDetailViewControllerConstants {
    static let PanDismissalThreshold: CGFloat = 200
    static let BouncebackDuration: Double = 0.3
}

class UserDetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelAge: UILabel!
    @IBOutlet private weak var labelLocation: UILabel!
    @IBOutlet private weak var viewContainer: UIView!
    
    let disposeBag = DisposeBag()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set image
        if let image = user?.picture?.large {
            imageView.kf.setImage(with: image, placeholder: #imageLiteral(resourceName: "UserPlaceholder"))
        }
        else {
            imageView.image = #imageLiteral(resourceName: "UserPlaceholder")
        }
        
        //Set details
        labelName.text = user?.login.username
        
        if let location = user?.location {
            labelLocation.text = "\(location.city), \(location.state)"
        }
        else {
            labelLocation.text = nil
        }
        
        if let age = user?.GetAge() {
            labelAge.text = "\(age) \(age > 1 ? "years" : "year")"
        }
        else {
            labelAge.text = nil
        }
        
        setupRx()
    }
    
    private func setupRx() {
        //Pan views down as the user pans with their finger
        self.viewContainer.rx
            .panGesture()
            .when(.changed)
            .asTranslation()
            .asDriverSkippingErrors()
            .drive(onNext: { [weak self] (point, velocity) in
                let yOffset: CGFloat = max(point.y, CGFloat.leastNormalMagnitude)
                
                if yOffset > UserDetailViewControllerConstants.PanDismissalThreshold {
                    self?.dismiss(animated: true, completion: nil)
                }
                else {
                    self?.imageView.transform = CGAffineTransform.init(translationX: 0, y: yOffset)
                }
            })
            .disposed(by: disposeBag)
        
        //Restore view position when user releases the pan
        self.viewContainer.rx
            .panGesture()
            .when(.ended)
            .asDriverSkippingErrors()
            .drive(onNext: { [weak self] _ in
                UIView.animate(withDuration: UserDetailViewControllerConstants.BouncebackDuration) {
                    self?.imageView.transform = CGAffineTransform.identity
                }
            })
            .disposed(by: disposeBag)
    }
}

