//
//  TeamDetailsViewController.swift
//  ScoreSphere
//
//  Created by Macos on 22/05/2025.
//

import UIKit

class TeamDetailsViewController: UIViewController, UITableViewDataSource, TeamDetailsViewProtocol {

    var presenter: TeamDetailsPresenterProtocol!
        
    var players: [Player] = []
    var coachName: String?
    var logoURL: String?
    var name: String?

    
    
    @IBOutlet weak var teamImg: UIImageView!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var teamList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamList.dataSource = self
        presenter.view = self
        presenter.fetchTeamDetails()
    }

       
       
       func showTeamDetails(_ teamDetails: TeamDetails) {
           name = teamDetails.team_name
           logoURL = teamDetails.team_logo
           coachName = teamDetails.coaches?.first?.coach_name
           players = teamDetails.players ?? []
           
           teamName.text = name
           if let urlStr = logoURL, let url = URL(string: urlStr) {
               loadImage(from: url)
           }
       }
       
       func reloadData() {
           teamList.reloadData()
       }
       
       
    func loadImage(from url: URL) {
           URLSession.shared.dataTask(with: url) { data, _, error in
               guard let data = data, error == nil else { return }
               DispatchQueue.main.async {
                   self.teamImg.image = UIImage(data: data)
               }
        }.resume()
    }
       
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return players.count + (coachName != nil ? 1 : 0)
    }
       
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as? PlayerTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.row == 0 && coachName != nil {
            cell.playerName.text = "Coach: \(coachName!)"
            cell.playerType.text = nil
            cell.playerImg.image = UIImage(named: "coachPlaceholder")
        } else {
            let playerIndex = coachName != nil ? indexPath.row - 1 : indexPath.row
            let player = players[playerIndex]
            
            cell.playerName.text = player.player_name
            cell.playerType.text = "\(player.player_type ?? "") - #\(player.player_number ?? "-")"
            cell.playerImg.image = UIImage(named: "placeholder")
            if let imageUrlString = player.player_image, let imageUrl = URL(string: imageUrlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if let updateCell = tableView.cellForRow(at: indexPath) as? PlayerTableViewCell {
                                updateCell.playerImg.image = image
                            }
                        }
                    }
                }
            }
        }

        return cell
    }


    }
