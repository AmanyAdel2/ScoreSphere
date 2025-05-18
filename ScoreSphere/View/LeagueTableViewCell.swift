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
//        leagueLogoImageView.contentMode = .scaleAspectFit
//        leagueLogoImageView.clipsToBounds = true
//        leagueLogoImageView.layer.cornerRadius = 8
        
    }

    func configure(with league: League) {
        leagueNameLabel.text = league.league_name

        if let logoURLString = league.league_logo, let url = URL(string: logoURLString) {
            leagueLogoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            leagueLogoImageView.image = UIImage(systemName: "photo")
        }
    }
}
