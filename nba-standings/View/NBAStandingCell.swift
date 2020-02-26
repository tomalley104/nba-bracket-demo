//
//  NBATeamStandingCell.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/9/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import Foundation
import UIKit

class NBAStandingCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!

    // TODO: change to VM property
    var viewModel: NBAStandingCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        logoImageView.image = viewModel?.logoImage
        nameLabel.text = viewModel?.nameLabelText
        winLabel.text = viewModel?.winLabelText
        lossLabel.text = viewModel?.lossLabelText
    }

    override func prepareForReuse() {
        logoImageView.image = nil
        nameLabel.text = nil
        winLabel.attributedText = nil
        lossLabel.attributedText = nil
        super.prepareForReuse()
    }
}
