//
//  ViewController.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/7/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let service = NBAAPIService()
    private var east = [NBAStanding]()
    private var west = [NBAStanding]()

    private let cellID = "nbaTeamCell"

    // MARK: View Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "\(NBATeamStandingCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshStandings), for: .valueChanged)
        tableView.refreshControl =  refreshControl

        refreshStandings()
    }

    @objc func refreshStandings() {
        service.getStandings { [weak self] result in
            switch result {
            case .success(let standings):
                self?.east.removeAll()
                self?.west.removeAll()

                let ranked = standings.sorted(by: { $0.rank < $1.rank })
                
                ranked.forEach { standing in
                
                    switch standing.conference {
                    case .east:
                        self?.east.append(standing)
                    case .west:
                        self?.west.append(standing)
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                assertionFailure("whoops: \(error.localizedDescription)")
            }
            
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return east.count
        case 1: return west.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NBATeamStandingCell
        let standings = (indexPath.section == 0 ? east : west)
        cell.standing = standings[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "EAST" : "WEST"
    }
}




