//
//  leagueDetailsCollectionViewController.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class LeagueDetailsCollectionViewController: UICollectionViewController {

    var fixtures: [Fixture] = []
    var standings: [Standing] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        collectionView.setCollectionViewLayout(createLayout(), animated: true)

        NetworkManager.shared.fetchFixtures(from: "2025-05-15", to: "2025-05-20", leagueId: "207") { fixtures in
            DispatchQueue.main.async {
                self.fixtures = fixtures
                self.collectionView.reloadData()
            }
        }

        NetworkManager.shared.fetchStandings(leagueId: "207") { standings in
            DispatchQueue.main.async {
                self.standings = standings
                self.collectionView.reloadData()
            }
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in

            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(400), heightDimension: .absolute(160))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(320), heightDimension: .absolute(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section

            case 1:
                // Section 1: Latest Events (vertical list, medium height)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                return section

            case 2:
                // Section 2: Teams (horizontal scroll, small items)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                return section

            default:
                return nil
            }
        }
    }


    func setupCollectionView() {
      
        collectionView.register(LatestEventCell.self, forCellWithReuseIdentifier: "LatestEventCell")
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: "TeamCell")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return fixtures.count
        case 1: return fixtures.count
        case 2: return standings.count
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
            let f = fixtures[indexPath.item]
            let event = Event(
                name: f.event_home_team + " vs " + f.event_away_team,
                date: f.event_date,
                time: f.event_time,
                homeTeam: f.event_home_team,
                awayTeam: f.event_away_team,
                homeScore: nil,
                awayScore: nil,
                homeTeamLogo: f.home_team_logo,
                awayTeamLogo: f.away_team_logo
            )
            cell.configure(with: event)
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventCell", for: indexPath) as! LatestEventCell
            let f = fixtures[indexPath.item]
            let event = Event(
                name: "",
                date: f.event_date,
                time: f.event_time,
                homeTeam: f.event_home_team,
                awayTeam: f.event_away_team,
                homeScore: f.event_final_result,
                awayScore: nil,
                homeTeamLogo: nil,
                awayTeamLogo: nil
            )
            cell.configure(with: event)
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            let team = standings[indexPath.item]
            let teamModel = Team(name: team.team_name, logoURL: "")
            cell.configure(with: teamModel)
            return cell

        default:
            fatalError("Unexpected section")
        }
    }
}
