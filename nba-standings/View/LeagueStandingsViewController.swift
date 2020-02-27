//
//  ViewController.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/7/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import UIKit

class LeagueStandingsViewController: UITableViewController {

    let viewModel: LeagueStandingsViewModel = .default()

    // MARK: View Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        setUpTableView()
        setUpRefreshControl()
        refreshStandings()
    }

    // MARK: Set Up

    private func setUpTableView() {
        tableView.rowHeight = viewModel.rowHeight
        tableView.register(viewModel.cellNib,
                           forCellReuseIdentifier: viewModel.cellID)
    }

    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshStandings),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: UIRefreshControl

    @objc func refreshStandings() {
        viewModel.refreshStandings { [weak self] result in

            var shouldReload = false
            defer {
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing()
                    if shouldReload {
                        self?.tableView.reloadData()
                    }
                }
            }

            switch result {
                case .success(let hasNew):
                    shouldReload = hasNew
                case .failure(let error):
                    // TODO: indicate this to the user
                    assertionFailure(error.localizedDescription)
            }
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellID,
                                                 for: indexPath) as! NBAStandingCell
        cell.viewModel = viewModel.cellViewModel(for: indexPath)
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
}
