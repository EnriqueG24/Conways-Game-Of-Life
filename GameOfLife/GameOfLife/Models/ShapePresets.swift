//
//  ShapePresets.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/28/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

// MARK: - Enum for Tool Selection
enum ToolPalette: String {
    case dot
    case block
    case blinker
    case glider
    case beacon
    case rectangle
}

class ShapePresets: UIView {
    
    // MARK: - Properties
    var size: Int
    var cellWidth: CGFloat
    var box = [[GridCells]]()
    var currentTool: ToolPalette = .dot
    
    // MARK: - Init
    init(size: Int, cellWidth: CGFloat, toolPalette: ToolPalette) {
        self.size = size
        self.currentTool = toolPalette
        self.cellWidth = cellWidth
        super.init(frame: CGRect(x: 0, y: 0, width: Int(cellWidth) * size, height: Int(cellWidth) * size))
        self.backgroundColor = .white
        box = setupPresetGrid()
        setupPreset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setupPreset() {
        switch currentTool {
        case .dot:
            box[0][0].aliveCell()
        case .block:
            box[0][0].aliveCell()
            box[0][1].aliveCell()
            box[1][0].aliveCell()
            box[1][1].aliveCell()
        case .blinker:
            box[1][0].aliveCell()
            box[1][1].aliveCell()
            box[1][2].aliveCell()
        case .glider:
            box[1][0].aliveCell()
            box[2][1].aliveCell()
            box[0][2].aliveCell()
            box[1][2].aliveCell()
            box[2][2].aliveCell()
        case .beacon:
            box[0][0].aliveCell()
            box[1][0].aliveCell()
            box[0][1].aliveCell()
            box[3][2].aliveCell()
            box[2][3].aliveCell()
            box[3][3].aliveCell()
        case .rectangle:
            box[0][0].aliveCell()
            box[1][0].aliveCell()
            box[2][0].aliveCell()
            box[0][1].aliveCell()
            box[1][1].aliveCell()
            box[2][1].aliveCell()
        }
    }
    
    func setupPresetGrid() -> [[GridCells]] {
        var grid = [[GridCells]]()
        var gridColumn = [GridCells]()
        for j in 0...(size - 1) {
            for i in 0...(size - 1) {
                let cell = GridCells(frame: CGRect(x: cellWidth * CGFloat(j), y: cellWidth * CGFloat(i), width: cellWidth, height: cellWidth))
                cell.isUserInteractionEnabled = false
                addSubview(cell)
                gridColumn.append(cell)
            }
            grid.append(gridColumn)
            gridColumn.removeAll()
        }
        return grid
    }
}
