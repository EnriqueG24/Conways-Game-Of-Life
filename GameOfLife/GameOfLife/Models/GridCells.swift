//
//  GridCells.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/27/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class GridCells: UIView {
    
    // MARK: - Properties
    var grid: Grid?
    var isAlive: Bool = false
    var color: UIColor {
        switch Settings.shared.cellColor {
        case .black:
            return .black
        case .blue:
            return .systemBlue
        case .green:
            return .systemGreen
        case .red:
            return .systemRed
        case .purple:
            return .systemPurple
        case .pink:
            return .systemPink
        case .teal:
            return .systemTeal
        case .indigo:
            return .systemIndigo
        case .orange:
            return .systemOrange
        case .yellow:
            return .systemYellow
        }
    }
    
    // MARK: - Init
    init(frame: CGRect, isAlive: Bool = false) {
        super.init(frame: frame)
        self.isAlive = isAlive
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(colorChanged), name: Notification.Name("didChangeCellColor"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    func configureView() {
        self.backgroundColor = UIColor(white: 5, alpha: 0.20)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func deadCell() {
        self.isAlive = false
        self.backgroundColor = UIColor(white: 1, alpha: 0.20)
    }
    
    func aliveCell() {
        isAlive = true
        self.backgroundColor = color
    }
    
    func getCoordinates() -> (x: Int, y: Int)? {
        for x in 0...24 {
            for y in 0...24 {
                if grid?.screenArray[x][y] == self {
                    return (x: x, y: y)
                }
            }
        }
        return nil
    }
    
    func checkFor4Coordinates(coordinates: (x: Int, y: Int)) {
        let rows = 25
        for i in coordinates.x...coordinates.x+1 {
            for j in coordinates.y...coordinates.y+1 {
                if ((i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0)) {
                    continue
                }
                guard let presetCellIsActive = grid?.currentPreset.box[i - coordinates.x ][j - coordinates.y].isAlive else { return }
                if presetCellIsActive {
                    grid?.screenArray[i][j].aliveCell()
                } else {
                    grid?.screenArray[i][j].deadCell()
                }
            }
        }
    }
    
    func checkFor9Coordinates(coordinates: (x: Int, y: Int)) {
        let rows = 25
        
        for i in coordinates.x-1...coordinates.x+1 {
            for j in coordinates.y-1...coordinates.y+1 {
                if ((i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0)) {
                    continue
                }
                
                guard let presetCellIsActive = grid?.currentPreset.box[i - coordinates.x + 1][j - coordinates.y + 1].isAlive else { return }
                if presetCellIsActive {
                    grid?.screenArray[i][j].aliveCell()
                } else {
                    grid?.screenArray[i][j].deadCell()
                }
            }
        }
    }
    
    func checkFor16Coordinates(coordinates: (x: Int, y: Int)) {
        let rows = 25
        
        for i in coordinates.x-1...coordinates.x+2 {
            for j in coordinates.y-1...coordinates.y+2 {
                if ((i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0)) {
                    continue
                }
                guard let presetCellIsActive = grid?.currentPreset.box[i - coordinates.x + 1][j - coordinates.y + 1].isAlive else { return }
                if presetCellIsActive {
                    grid?.screenArray[i][j].aliveCell()
                } else {
                    grid?.screenArray[i][j].deadCell()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let preset = grid?.currentPreset else { return }
        guard let coordinates = getCoordinates() else { return }
        if preset.box.count == 1 {
            if isAlive == false {
                aliveCell()
            } else {
                deadCell()
            }
        } else if ((preset.box.count * preset.box.count) / 2) == 2 {
            checkFor4Coordinates(coordinates: coordinates)
        } else if ((preset.box.count * preset.box.count) / 2) == 4 {
            checkFor9Coordinates(coordinates: coordinates)
        } else if ((preset.box.count * preset.box.count) / 2) == 8 {
            checkFor16Coordinates(coordinates: coordinates)
        }
    }
    
    // MARK: - Objective-C Methods
    @objc func colorChanged() {
        if isAlive {
            backgroundColor = color
        }
    }
}
