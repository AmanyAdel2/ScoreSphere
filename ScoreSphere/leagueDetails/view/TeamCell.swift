//
//  TeamCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class TeamCell: UICollectionViewCell {
    let imageView = UIImageView()

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamImg: UIImageView!
    
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 2
        }
            
        
        func configure(with team: TeamsStanding) {
            teamName.text = team.teamName
            if let logoURL = team.teamLogo, let url = URL(string: logoURL) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.teamImg.image = UIImage(data: data)
                        }
                    }
                }.resume()
            } else {
                teamImg.image = UIImage(systemName: "")
            }
        }

    }
  
    

