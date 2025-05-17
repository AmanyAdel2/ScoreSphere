//
//  LatestEventCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class LatestEventCell: UICollectionViewCell {
    let label = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)
            label.frame = bounds
            label.numberOfLines = 4
            label.textAlignment = .center
            contentView.addSubview(label)
            backgroundColor = .systemBlue
            layer.cornerRadius = 12
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(with event: Event) {
            label.text = "\(event.homeTeam) vs \(event.awayTeam)\n\(event.homeScore ?? "-") : \(event.awayScore ?? "-")\n\(event.date) at \(event.time)"
        }
}
