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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
