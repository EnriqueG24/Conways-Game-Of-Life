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
    
    // MARK: - Init
    init(frame: CGRect, isAlive: Bool = false) {
        super.init(frame: frame)
        self.isAlive = isAlive
        configureView()
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
        self.backgroundColor = UIColor.systemGreen
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
}
