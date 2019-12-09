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
    var teams = [NBATeam]() {
        didSet {
//            if oldValue != self.teams {
                tableView.reloadData()
//            }
        }
    }

    // MARK: View Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        client.fetchCurrentLeagueStandings { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    self?.teams = teams
                case .failure(let error):
                    self?.teams = []
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
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)

        let team = teams[indexPath.row]
        cell.textLabel?.text = "\(team.name) \(team.nickname)"
        cell.detailTextLabel?.text = "\(team.win) W  |  \(team.loss) L"

        return cell
    }
}




