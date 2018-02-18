//
//  UserCollectionViewCell.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import UIKit
import Kingfisher

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelAge: UILabel!
    
    var user: User? {
        didSet {
            //Set image
            if let image = user?.picture?.medium {
                imageView.kf.setImage(with: image)
            }
            else {
                imageView.kf.setImage(with: nil) //TODO: Use placeholder
            }
            
            //Set details
            labelName.text = user?.login.username
            
            if let age = user?.GetAge() {
                labelAge.text = "\(age) \(age > 1 ? "years" : "year")"
            }
            else {
                labelAge.text = nil
            }
        }
    }
}
