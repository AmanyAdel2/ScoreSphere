//
//  leaguesTableViewController.swift
//  ScoreSphere
//
//  Created by Macos on 18/05/2025.
//

import UIKit

class leaguesTableViewController: UITableViewController, LeaguesViewProtocol {
    
    var sportName: String!
    var presenter: LeaguesPresenterProtocol!
    
    private var leagues: [League] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(sportName ?? "") Leagues"
        
        presenter = LeaguesPresenter(view: self)
        presenter.getLeagues(for: sportName)
        leagues = [
            League(league_key: 1, league_name: "Test League 1", country_key: 1, country_name: "Country A", league_logo: nil, country_logo: nil),
            League(league_key: 2, league_name: "Test League 2", country_key: 2, country_name: "Country B", league_logo: nil, country_logo: nil)
        ]
        tableView.reloadData()
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LeagueCell")
    }
    
    // MARK: - LeaguesViewProtocol
    
    func showLeagues(_ leagues: [League]) {
        DispatchQueue.main.async {
            self.leagues = leagues
            self.tableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt called for row \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueTableViewCell else {
            print("Failed to dequeue LeagueTableViewCell")
            return UITableViewCell()
        }
        
        let league = leagues[indexPath.row]
        cell.configure(with: league)
        cell.onFavoriteTapped = {
            let league = self.leagues[indexPath.row]
            let repo = RepositoryImp()
            let useCase = FavoriteLeaguesUseCase(repo: repo)
            if let sportName = self.sportName,
               let sportType = SportType(rawValue: sportName.lowercased()) {
                UIApplication.shared.showToastOnWindow(message: "Added to favorites!")

                useCase.saveToFavorite(league, sportType: sportType)
            } else {
                print("Invalid or missing sportName for saving favorite")
            }

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLeague = leagues[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController {
            
            guard let sportName = sportName,
                  let sportType = SportType(rawValue: sportName.lowercased()) else {
                return
            }
            detailsVC.sportType = sportType
            detailsVC.leagueId = "\(selectedLeague.league_key)"
            
            navigationController?.pushViewController(detailsVC, animated: true)
        }
        
        
    }
}
extension UIApplication {
    func showToastOnWindow(message: String, duration: Double = 2.0) {
        guard let window = windows.first(where: { $0.isKeyWindow }) else { return }
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = .systemGreen
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0

        let maxWidth = window.frame.size.width - 40
        let maxSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        expectedSize.width = min(expectedSize.width + 40, maxWidth)

        toastLabel.frame = CGRect(
            x: (window.frame.size.width - expectedSize.width) / 2,
            y: window.frame.size.height - expectedSize.height - 80 - window.safeAreaInsets.bottom,
            width: expectedSize.width,
            height: expectedSize.height + 20
        )

        window.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
