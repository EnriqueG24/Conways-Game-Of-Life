//
//  GameOfLifeViewController.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/27/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class GameOfLifeViewController: UIViewController {

    // MARK: - Properties
    var grid: Grid!
    var timer = Timer()
    var isRunning = false
    let presetView = UIView()
    var label = UILabel()
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: UIBarButtonItem) {
        grid.configureTimer()
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradient()
    }
    
    // MARK: - Methods
    func backgroundGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.systemTeal.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
    }
    
}
