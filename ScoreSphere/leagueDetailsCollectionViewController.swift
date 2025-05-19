//
//  leagueDetailsCollectionViewController.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class LeagueDetailsCollectionViewController: UICollectionViewController {


    var upcomingFixtures: [Fixture] = []
    var latestFixtures: [Fixture] = []
    var teamStandings: [TeamsStanding] = []

    var sportName: String!
    var leagueId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        guard let leagueId = leagueId else {
            print("leagueId is nil")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let oneWeekAhead = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        let oneWeekBefore = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        
        let fromDate = dateFormatter.string(from: oneWeekBefore)
        let toDate = dateFormatter.string(from: oneWeekAhead)
        
        NetworkManager.shared.fetchFixtures(from: fromDate, to: toDate, leagueId: leagueId) { [weak self] fixtures in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.upcomingFixtures = fixtures.filter { fixture in
                    guard let fixtureDate = dateFormatter.date(from: fixture.event_date) else { return false }
                    return fixtureDate > today
                }
                
                self.latestFixtures = fixtures.filter { fixture in
                    guard let fixtureDate = dateFormatter.date(from: fixture.event_date) else { return false }
                    return fixtureDate <= today
                }
                
                self.collectionView.reloadData()
            }
        }
        
        NetworkManager.shared.fetchTeams(leagueId: leagueId) { [weak self] teamsResponse in
            DispatchQueue.main.async {
                self?.teamStandings = teamsResponse
                self?.collectionView.reloadData()
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(180))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(180), heightDimension: .absolute(180))
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return upcomingFixtures.count
        case 1: return latestFixtures.count
        case 2: return teamStandings.count
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
            let fixture = upcomingFixtures[indexPath.item]
            let event = Event(
                name: "\(fixture.event_home_team) vs \(fixture.event_away_team)",
                date: fixture.event_date,
                time: fixture.event_time,
                homeTeam: fixture.event_home_team,
                awayTeam: fixture.event_away_team,
                homeScore: nil,
                awayScore: nil,
                homeTeamLogo: fixture.home_team_logo,
                awayTeamLogo: fixture.away_team_logo
            )
            cell.configure(with: event)
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventCell", for: indexPath) as! LatestEventCell
            let fixture = latestFixtures[indexPath.item]
            let event = Event(
                name: "\(fixture.event_home_team) vs \(fixture.event_away_team)",
                date: fixture.event_date,
                time: fixture.event_time,
                homeTeam: fixture.event_home_team,
                awayTeam: fixture.event_away_team,
                homeScore: fixture.event_final_result,
                awayScore: nil,
                homeTeamLogo: fixture.home_team_logo,
                awayTeamLogo: fixture.away_team_logo
            )
            cell.configure(with: event)
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            let team = teamStandings[indexPath.item]
            cell.configure(with: team)
            return cell

        default:
            fatalError("Unexpected section \(indexPath.section)")
        }
    }
}
