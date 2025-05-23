//
//  TeamsViewControllerTableViewController.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit
import SDWebImage

class TeamsViewController: UITableViewController, TeamView {
    
    var presenter: TeamPresenter!
    var teams: [Team] = []
    var leagueId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TeamPresenter(view: self)
        presenter.fetchTeams(forLeagueId: leagueId)
    }

    func showTeams(_ teams: [Team]) {
        self.teams = teams
        tableView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TableViewCell
        let team = teams[indexPath.row]
        cell.teamNameLabel.text = team.name
        if let logoURL = team.logoURL, let url = URL(string: logoURL) {
            cell.teamImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        return cell
    }
}
