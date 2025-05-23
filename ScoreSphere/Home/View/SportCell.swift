//
//  SportCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class SportCell: UICollectionViewCell {
    @IBOutlet weak var sportImageView: UIImageView!
    
    @IBOutlet weak var sportName: UILabel!
   override func awakeFromNib() {
        contentView.layer.borderWidth = 2.0
                contentView.layer.borderColor = UIColor.black.cgColor
                contentView.layer.cornerRadius = 8.0
                contentView.layer.masksToBounds = true
    }
}
