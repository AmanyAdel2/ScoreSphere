//
//  LatestEventCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class LatestEventCell: UICollectionViewCell {
    let label = UILabel()

    @IBOutlet weak var teamOneImg: UIImageView!
    
    @IBOutlet weak var teamOneName: UILabel!
    
    
    @IBOutlet weak var teamTwoImg: UIImageView!
    
    @IBOutlet weak var teamTwoName: UILabel!
    
    @IBOutlet weak var finalResult: UILabel!
    
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupViews()
        }
        
        private func setupViews() {
            teamOneImg.contentMode = .scaleAspectFit
            teamTwoImg.contentMode = .scaleAspectFit
            
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 0.5
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
    
    
    
    func configure(with event: Event) {
        teamOneName.text = event.homeTeam
        teamTwoName.text = event.awayTeam
        finalResult.text = event.homeScore ?? "N/A"

        if let logoURL = event.homeTeamLogo, let url = URL(string: logoURL) {
            loadImage(from: url, into: teamOneImg)
        } else {
            teamOneImg.image = UIImage(systemName: "house.fill")
        }

        if let logoURL = event.awayTeamLogo, let url = URL(string: logoURL) {
            loadImage(from: url, into: teamTwoImg)
        } else {
            teamTwoImg.image = UIImage(systemName: "building.2.fill")
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
