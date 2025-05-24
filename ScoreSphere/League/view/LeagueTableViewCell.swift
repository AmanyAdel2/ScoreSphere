//
//  LeagueTableViewCell.swift
//  ScoreSphere
//
//  Created by Macos on 18/05/2025.
//

import UIKit
import SDWebImage  // Recommended for async image loading and caching

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueLogoImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.systemBlue.cgColor
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
        
        
        
    }

    func configure(with league: League) {
        leagueNameLabel.text = league.league_name

        if let logoURLString = league.league_logo, let url = URL(string: logoURLString) {
            leagueLogoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "trophy"))
            
        } else {
            leagueLogoImageView.image = UIImage(named: "trophy")
        }
    }
    
    var onFavoriteTapped: (() -> Void)?
    
    @IBAction func addToFavorite(_ sender: Any) {
        onFavoriteTapped?()
        
    }
}
