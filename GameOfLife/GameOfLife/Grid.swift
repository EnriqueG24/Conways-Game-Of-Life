//
//  Grid.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/27/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit


class Grid {
    // MARK: - Properties
    var width: CGFloat!
    var height: CGFloat!
    var view: UIView!
    var cellSize: CGFloat!
    var timer: Timer = Timer()
    var screenArray = [[GridCells]]()
    var nextArray = [[GridCells]]()
    
    // MARK: - Computed Properties
    var generations = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("generationChanged"), object: nil, userInfo: ["generations": generations])
        }
    }
    
    // MARK: - Init
    init(width: CGFloat, height: CGFloat, view: UIView) {
        self.width = width
        self.height = height
        self.view = view
        self.cellSize = width / 25
        self.screenArray = setupGrid(width: width, height: height, view: view)
        self.nextArray = setupGrid(width: width, height: height, view: view, isNext: true)
    }
    
    // MARK: - Methods
    func countNeighbors(x: Int, y: Int) -> Int {
        var count = 0
        let rows = 25
        
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if (i == x && j == y) || (i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0) {
                    continue
                }
                if screenArray[i][j].isAlive { count += 1}
            }
        }
        return count
    }
    
    func draw() {
        for x in 0...24 {
            for y in 0...24 {
                nextArray[x][y].isAlive ? screenArray[x][y].aliveCell() : screenArray[x][y].deadCell()
            }
        }
        
    }
    
    func resetGrid(grid: [[GridCells]]) {
        for x in 0...24 {
            for y in 0...24 {
                grid[x][y].deadCell()
            }
        }
    }
    
    func computeNext() {
        resetGrid(grid: nextArray)
        
        for x in 0...24 {
            for y in 0...24 {
                let state = screenArray[x][y].isAlive
                let neighbors = countNeighbors(x: x, y: y)
                
                if state == true {
                    if neighbors == 2 || neighbors == 3 {
                        nextArray[x][y].aliveCell()
                    } else {
                        nextArray[x][y].deadCell()
                    }
                } else {
                    if neighbors == 3 {
                        nextArray[x][y].aliveCell()
                    }
                }
            }
        }
        draw()
    }
    
    func run() {
        generations += 1
        computeNext()
    }
    
    func setupGrid(width: CGFloat, height: CGFloat, view: UIView, isNext: Bool = false) -> [[GridCells]] {
        var gridcells = [[GridCells]]()
        var gridcolumn = [GridCells]()
        for i in 0...24 {
            for j in 0...24 {
                let cell = GridCells(frame: CGRect(x: width / 25 * CGFloat(j), y: height / 2 - width / 2 + width / 25 * CGFloat(i), width: width / 25, height: width / 25), isAlive: false)
                cell.grid = self
                if !isNext {
                    view.addSubview(cell)
                }
                gridcolumn.append(cell)
            }
            gridcells.append(gridcolumn)
            gridcolumn.removeAll()
        }
        return gridcells
    }
}
