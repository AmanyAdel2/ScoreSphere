//
//  PlayerTableViewCell.swift
//  ScoreSphere
//
//  Created by Macos on 22/05/2025.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImg: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    
    @IBOutlet weak var playerType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
