//
//  Settings.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/28/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit
enum CellColor: Int {
    case black = 1
    case green
    case blue
    case red
    case purple
    case pink
    case teal
    case indigo
    case orange
    case yellow
}

class Settings {
    static let shared = Settings()
    var cellColor: CellColor = .black {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("didChangeCellColor"), object: nil)
        }
    }
}
