//
//  FavoriteViewController.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, FavoriteLeaguesViewProtocol {
    
    
    
    @IBOutlet weak var favTableView: UITableView!
    var presenter: FavoriteLeaguesPresenter!
       var favorites: [FavoriteLeagues] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite Leagues"
        
        favTableView.delegate = self
        favTableView.dataSource = self
        let repo = RepositoryImp()
        let useCase = FavoriteLeaguesUseCase(repo: repo)
        presenter = FavoriteLeaguesPresenter(view: self, useCase: useCase)
       favTableView.rowHeight = UITableView.automaticDimension
      favTableView.estimatedRowHeight = 100
       
      //  favTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteCell")

       

        
        
        
        
    }

    
    
    
    

        // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of favorites: \(favorites.count)")
        return favorites.count
    }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("Configuring cell at row: \(indexPath.row)")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
            print("Cell class: \(type(of: cell))")



            let favorite = favorites[indexPath.row]
       

            cell.favoriteLeagueName.text = favorite.league_name
            if let logoURL = favorite.league_logo, let url = URL(string: logoURL) {
                cell.favoriteLeagueLogo.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            }
           
            
            
            return cell
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedFavorite = favorites[indexPath.row]

            let alert = UIAlertController(
                title: "Delete Favorite",
                message: "Are you sure you want to remove this league from favorites?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.presenter.deleteFavorite(at: indexPath.row, from: self.favorites)
            })

            present(alert, animated: true, completion: nil)
        }
    }



   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadFavorites()
    }

    func showFavoriteLeague(_ favorites: [FavoriteLeagues]) {
        for fav in favorites {
                print("league_name: \(fav.league_name ?? "nil"), sport_type: \(fav.sport_type ?? "nil")")
            }
        DispatchQueue.main.async {
               self.favorites = favorites
               self.favTableView.reloadData()
           }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFavorite = favorites[indexPath.row]

        guard let sportTypeString = selectedFavorite.sport_type,
              let sportType = SportType(rawValue: sportTypeString) else {
            print("Missing or invalid sport_type in CoreData for league: \(selectedFavorite.league_name ?? "Unknown")")
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController {

            detailsVC.leagueId = String(selectedFavorite.league_key)
            detailsVC.sportType = sportType
            navigationController?.pushViewController(detailsVC, animated: true)
        } else {
            print("Failed to instantiate LeagueDetailsCollectionViewController")
        }
    }

    }


    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


