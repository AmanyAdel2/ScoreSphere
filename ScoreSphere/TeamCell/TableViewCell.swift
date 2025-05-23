//
//  TableViewCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
