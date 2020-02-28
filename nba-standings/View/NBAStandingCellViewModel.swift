//
//  NBAStandingCellViewModel.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/26/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation
import UIKit

struct NBAStandingCellViewModel {
    let standing: NBAStanding

    var logoImage: UIImage? {
        return UIImage(named: standing.team.shortName)
    }

    var nameLabelText: String {
        return standing.team.fullName
    }

    var winLabelText: String {
        return standing.win + " W"
    }

    var lossLabelText: String {
        return standing.loss + " L"
    }
}
