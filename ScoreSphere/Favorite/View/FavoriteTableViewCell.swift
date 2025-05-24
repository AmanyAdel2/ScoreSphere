//
//  FavoriteTableViewCell.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    
   
    @IBOutlet weak var favoriteLeagueName: UILabel!
    
    @IBOutlet weak var favoriteLeagueLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.systemBlue.cgColor
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
