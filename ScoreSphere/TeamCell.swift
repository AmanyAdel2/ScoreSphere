//
//  TeamCell.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class TeamCell: UICollectionViewCell {
    let imageView = UIImageView()

        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.frame = bounds
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = frame.width / 2
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            backgroundColor = .systemGreen
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(with team: Team) {
            imageView.image = UIImage(systemName: "person.circle") // Placeholder
            // Replace with actual image loading from `team.logo`
        }
}
