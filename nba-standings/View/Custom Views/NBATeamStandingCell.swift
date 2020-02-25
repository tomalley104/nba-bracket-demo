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
    
    var standing: NBAStanding! {
        didSet {
            updateUI(for: standing)
        }
    }

    private func updateUI(for standing: NBAStanding) {
        logoImageView.image = UIImage(named: standing.shortName)
        nameLabel.text  = standing.fullName
        winLabel.text = standing.win + " W"
        lossLabel.text = standing.loss + " L"
    }

    override func prepareForReuse() {
        logoImageView.image = nil
        [nameLabel, winLabel, lossLabel].forEach { $0.text = nil }
        super.prepareForReuse()
    }
}
