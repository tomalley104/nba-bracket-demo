//
//  NBATeamStandingCell.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/9/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import Foundation
import UIKit

class NBATeamStandingCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!

    func update(for team: NBA.Team) {
        logoImageView.image = UIImage(named: team.nickname.lowercased())
        nameLabel.text  = team.fullName
        winLabel.text = team.stats.wins + " W"
        lossLabel.text = team.stats.losses + " L"
    }

    override func prepareForReuse() {
        logoImageView.image = nil
        [nameLabel, winLabel, lossLabel].forEach { $0.text = nil }
        super.prepareForReuse()
    }
}
