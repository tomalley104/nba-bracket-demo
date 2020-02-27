//
//  LeagueStandingsViewModel.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/26/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation
import UIKit

class LeagueStandingsViewModel {
    
    static func `default`() -> LeagueStandingsViewModel {
        let service = NBAAPIService.default()
        return LeagueStandingsViewModel(apiService: service)
    }
    
    // MARK: UIViewController
    let title: String = "2019-20 NBA Standings"
    
    // MARK: UITableView
    var numberOfSections = 2
    let rowHeight: CGFloat = 100
    let cellID: String = "\(NBAStandingCell.self)"
    var cellNib: UINib {
        return UINib(nibName: "\(NBAStandingCell.self)", bundle: .main)
    }
    
    // MARK: Standings
    private let apiService: NBAAPIServiceType
    private var cellVMs: (east: [NBAStandingCellViewModel], west: [NBAStandingCellViewModel])
    
    // MARK: Init
    
    init(apiService: NBAAPIServiceType, cachedStandings: [NBAStanding]? = nil) {
        self.apiService = apiService
        self.cellVMs = (east: [], west: [])
        
        if let standings = cachedStandings {
            createCellViewModels(for: standings)
        }
    }
    
    // MARK: UITableView Functions
    
    func numberOfRows(in section: Int) -> Int {
        switch section {
            case 0: return cellVMs.east.count
            case 1: return cellVMs.west.count
            default: return 0
        }
    }
    
    func titleForHeader(in section: Int) -> String? {
        switch section {
            case 0: return "EAST"
            case 1: return "WEST"
            default: return nil
        }
    }
    
    func cellViewModel(for indexPath: IndexPath) -> NBAStandingCellViewModel {
        switch indexPath.section {
            case 0: return cellVMs.east[indexPath.row]
            case 1: return cellVMs.west[indexPath.row]
            default:
                fatalError("\(type(of: self)) - Section \(indexPath.section) out of bounds")
        }
    }
    
    // MARK: Fetching Data
    
    func refreshStandings(completion: @escaping (Result<Bool, Error>) -> Void) {
        apiService.getStandings { [weak self] result in
            switch result {
                case .success(let standings):
                    let hasNew = (self?.createCellViewModels(for: standings) ?? false)
                    completion(.success(hasNew))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    // MARK: Helper
    
    @discardableResult private func createCellViewModels(for standings: [NBAStanding]) -> Bool {
        cellVMs.east.removeAll(keepingCapacity: true)
        cellVMs.west.removeAll(keepingCapacity: true)
        
        let ranked = standings.sorted(by: { $0.rank < $1.rank })
        ranked.forEach { standing in
            let newVM = NBAStandingCellViewModel(standing: standing)
            switch standing.conference {
                case .east: cellVMs.east.append(newVM)
                case .west: cellVMs.west.append(newVM)
            }
        }
        
        // TODO:
        // check if we have updated information.
        // for now just assume we have new data.
        return true
    }
}
