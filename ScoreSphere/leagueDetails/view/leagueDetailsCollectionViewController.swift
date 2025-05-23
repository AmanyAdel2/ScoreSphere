//
//  LeagueDetailsCollectionViewController.swift
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

    var teams: [TeamsStanding] = []

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
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
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
                section.boundarySupplementaryItems = [sectionHeader]

                return section

            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.boundarySupplementaryItems = [sectionHeader]

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
                section.boundarySupplementaryItems = [sectionHeader]

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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        
        let teams = presenter.getTeamStandings()
        guard indexPath.item < teams.count else { return }
        
        let selectedTeam = teams[indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController {
            
            let teamDetailsPresenter: TeamDetailsPresenterProtocol = TeamDetailsPresenter()
            
            teamDetailsPresenter.teamId = selectedTeam.teamKey
            teamDetailsPresenter.sport = self.sportType
            
            vc.presenter = teamDetailsPresenter
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unsupported kind")
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeader",
            for: indexPath
        ) as! SectionHeaderView

        switch indexPath.section {
        case 0: header.titleLabel.text = "Upcoming Events"
        case 1: header.titleLabel.text = "Latest Events"
        case 2: header.titleLabel.text = "Teams"
        default: header.titleLabel.text = ""
        }

        return header
    }


}

