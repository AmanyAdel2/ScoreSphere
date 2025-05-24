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
                cell.favoriteLeagueLogo.sd_setImage(with: url, placeholderImage: UIImage(named: "trophy"))
            }else {
                cell.favoriteLeagueLogo.image = UIImage(named: "trophy")
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
        DispatchQueue.main.async {
            self.favorites = favorites
            self.favTableView.reloadData()
            
            if self.favorites.isEmpty {
                self.setEmptyPlaceholder(
                    image: UIImage(named: "image") ?? UIImage(systemName: "star"),
                    message: "No favorite leagues yet."
                )
            } else {
                self.restoreTableView()
            }
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
    func setEmptyPlaceholder(image: UIImage?, message: String) {
        let placeholderView = UIView(frame: favTableView.bounds)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        placeholderView.addSubview(imageView)
        placeholderView.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor, constant: -20)
        ])

        favTableView.backgroundView = placeholderView
        favTableView.separatorStyle = .none
    }
    func restoreTableView() {
        favTableView.backgroundView = nil
        favTableView.separatorStyle = .singleLine
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


