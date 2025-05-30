//
//  UpcomingEventCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class UpcomingEventCell: UICollectionViewCell {
    @IBOutlet weak var fTeamImg: UIImageView!
    @IBOutlet weak var sTeamImg: UIImageView!
    @IBOutlet weak var fTeamName: UILabel!
    @IBOutlet weak var sTeamName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
        
            
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 2
            fTeamImg.contentMode = .scaleAspectFit
            sTeamImg.contentMode = .scaleAspectFit
        }

        func configure(with event: Event) {
                fTeamName.text = event.homeTeam
                sTeamName.text = event.awayTeam
                date.text = event.date
                time.text = event.time

                if let homeURL = URL(string: event.homeTeamLogo ?? "") {
                    loadImage(from: homeURL, into: fTeamImg)
                } else {
                    fTeamImg.image = nil
                }

                if let awayURL = URL(string: event.awayTeamLogo ?? "") {
                    loadImage(from: awayURL, into: sTeamImg)
                } else {
                    sTeamImg.image = nil
                }
            }

            private func loadImage(from url: URL, into imageView: UIImageView) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, error == nil {
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
    
}
