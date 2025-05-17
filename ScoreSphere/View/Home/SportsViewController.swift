//
//  SportsViewController.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class SportsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectionView: UICollectionView!

    let sports = [
            ("football", "207"),
            ("basketball", "134"),
            ("cricket", "119"),
            ("tennis", "273")
        ]

        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

            print("loaded")
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return sports.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath) as! SportCell
            let sport = sports[indexPath.row]
            print(sport.0)
            cell.sportImageView.image = UIImage(named: sport.0)
            return cell
        }

        // MARK: - 2x2 Grid Layout Configuration
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

            let spacing: CGFloat = 10
            let totalSpacing = spacing * 3 // 2 items + left + right insets
            let width = (collectionView.bounds.width - totalSpacing) / 2
            return CGSize(width: width, height: width)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TeamsViewController") as! TeamsViewController
        vc.leagueId = sports[indexPath.row].1
        navigationController?.pushViewController(vc, animated: true)
    }
    }
