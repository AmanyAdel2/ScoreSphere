//
//  LatestEventCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class LatestEventCell: UICollectionViewCell {

    @IBOutlet weak var teamOneImg: UIImageView!
    
    @IBOutlet weak var teamOneName: UILabel!
    
    
    @IBOutlet weak var teamTwoImg: UIImageView!
    
    @IBOutlet weak var teamTwoName: UILabel!
    
    @IBOutlet weak var finalResult: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            teamOneImg.contentMode = .scaleAspectFit
            teamTwoImg.contentMode = .scaleAspectFit
            
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 2
        }
        
        func configure(with event: Event) {
            teamOneName.text = event.homeTeam
            teamTwoName.text = event.awayTeam
            finalResult.text = event.homeScore ?? "N/A"
            
            date.text = event.date
            time.text = event.time

            if let logoURL = event.homeTeamLogo, let url = URL(string: logoURL) {
                loadImage(from: url, into: teamOneImg)
            } else {
                teamOneImg.image = UIImage(systemName: "")
            }

            if let logoURL = event.awayTeamLogo, let url = URL(string: logoURL) {
                loadImage(from: url, into: teamTwoImg)
            } else {
                teamTwoImg.image = UIImage(systemName: "")
            }
        }



        func loadImage(from url: URL, into imageView: UIImageView) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }.resume()
        }
}
