//
//  PresetTableViewCell.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/28/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class PresetTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String = "PresetCell"
    var preset: ShapePresets!
    var label = UILabel()
    
    // MARK: - Methods
    func set(preset: ShapePresets) {
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        preset.translatesAutoresizingMaskIntoConstraints = false
        self.preset = preset
        label.text = preset.currentTool.rawValue.capitalized
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.40)
        layer.backgroundColor = UIColor.clear.cgColor
    }
}
