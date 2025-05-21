//
//  leagueDetailsCollectionViewController.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import UIKit

class LeagueDetailsCollectionViewController: UICollectionViewController, LeagueDetailsViewProtocol {
    
    var presenter: LeagueDetailsPresenterProtocol!
    
    var sportType: SportType! {
        didSet {
            if let presenter = presenter as? LeagueDetailsPresenter {
                presenter.sportType = sportType
            }
        }
    }
    var leagueId: String! {
        didSet {
            if let presenter = presenter as? LeagueDetailsPresenter {
                presenter.leagueId = leagueId
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        presenter = LeagueDetailsPresenter()
        if let presenter = presenter as? LeagueDetailsPresenter {
            presenter.view = self
            presenter.sportType = sportType
            presenter.leagueId = leagueId
        }
        
        presenter.fetchData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(360), heightDimension: .absolute(160))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(320), heightDimension: .absolute(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section

            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
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
        case 0: return presenter.getUpcomingFixtures().count
        case 1: return presenter.getLatestFixtures().count
        case 2: return presenter.getTeamStandings().count
        default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
            let fixture = presenter.getUpcomingFixtures()[indexPath.item]
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
            let fixture = presenter.getLatestFixtures()[indexPath.item]
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
            let team = presenter.getTeamStandings()[indexPath.item]
            cell.configure(with: team)
            return cell
            
        default:
            fatalError("Unexpected section \(indexPath.section)")
        }
    }
}
