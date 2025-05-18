//
//  SportsViewController.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class SportsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectionView: UICollectionView!

    

       
        let sports: [Sport] = [
                Sport(name: "Football", imageName: "football"),
                Sport(name: "Basketball", imageName: "basketball"),
                Sport(name: "Cricket", imageName: "cricket"),
                Sport(name: "Tennis", imageName: "tennis")
            ]

            override func viewDidLoad() {
                super.viewDidLoad()
                collectionView.delegate = self
                collectionView.dataSource = self
            }

            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return sports.count
            }

            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath) as! SportCell
                let sport = sports[indexPath.item]
                cell.sportImageView.image = UIImage(named: sport.imageName)
                return cell
            }

            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let selectedSport = sports[indexPath.row].name
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let leaguesVC = storyboard.instantiateViewController(withIdentifier: "leaguesTableViewController") as? leaguesTableViewController {
                    leaguesVC.sportName = selectedSport

                    navigationController?.pushViewController(leaguesVC, animated: true)
                }
            }
        }
