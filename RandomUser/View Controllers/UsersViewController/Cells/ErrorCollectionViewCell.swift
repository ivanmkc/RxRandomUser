//
//  ErrorCollectionViewCell.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import UIKit

class ErrorCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var labelError: UILabel!
    
    var error: Error? {
        didSet {
            labelError.text = error?.localizedDescription
        }
    }
}

