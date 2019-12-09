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

    let client = NBADataClient()
    var nba: NBA = .empty {
        didSet {
            tableView.reloadData()
            navigationItem.title = "NBA \(nba.year)"
        }
    }

    // MARK: View Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        client.fetchCurrentLeagueStandings { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nba):
                    self?.nba = nba
                case .failure(let error):
                    self?.nba = .empty
                    let alert = UIAlertController(title: "Error",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nba.easternConference.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
        let teams = (indexPath.section == 0 ? nba.easternConference : nba.westernConference)
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.fullName
        cell.detailTextLabel?.text = "\(team.stats.wins) W  |  \(team.stats.losses) L"

        return cell
    }
}




