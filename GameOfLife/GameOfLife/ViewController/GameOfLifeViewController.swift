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
    var label = UILabel()
    var presetTableView = UITableView()
    let presetView = UIView()
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: UIBarButtonItem) {
        grid.configureTimer()
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradient()
        grid = Grid(width: self.view.frame.width, height: self.view.frame.height, view: self.view)
        setupPreset()
        setupTableView()
        configurePresets()
        configurePresetBar()
        configureCurrentPresetView(index: 0)
    }
    
    // MARK: - Methods
    func configurePresets() {
        grid.presets.append(ShapePresets(size: 1, cellWidth: grid.cellSize, toolPalette: .dot))
        grid.presets.append(ShapePresets(size: 2, cellWidth: grid.cellSize, toolPalette: .block))
        grid.presets.append(ShapePresets(size: 3, cellWidth: grid.cellSize, toolPalette: .blinker))
    }
    
    func configurePresetBar() {
        presetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presetView)
        presetView.backgroundColor = .clear
    }
    
    func configureCurrentPresetView(index: Int) {
        // TO-DO: Need to add constraints
        if grid.currentPreset != nil {
            grid.currentPreset.removeFromSuperview()
        }
        
        let selectedPreset = grid.presets[index]
        let preset = ShapePresets(size: selectedPreset.size, cellWidth: selectedPreset.cellWidth, toolPalette: selectedPreset.currentTool)
        grid.currentPreset = preset
        preset.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(preset)
        label.text = "Current Tool: " + grid.currentPreset.currentTool.rawValue.capitalized
    }
    
    func backgroundGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.systemTeal.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
    }
    
    func setupPreset() {
        // TO-DO: Need to add constraints
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        self.presetTableView = tableView
    }
    
    func setupTableView() {
        self.presetTableView.dataSource = self
        self.presetTableView.delegate = self
        self.presetTableView.allowsSelection = true
        self.presetTableView.register(PresetTableViewCell.self, forCellReuseIdentifier: "PresetCell")
        presetTableView.backgroundColor = .clear
    }
}

extension GameOfLifeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grid.presets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresetCell", for: indexPath) as! PresetTableViewCell
        cell.set(preset: grid.presets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configureCurrentPresetView(index: indexPath.row)

        if indexPath.row == 6 {
        grid.resetGrid(grid: grid.screenArray)
            for x in 0...24 {
                for y in 0...24 {
                    let rand = Int.random(in: 0...4)
                    if rand == 1 {
                        grid.screenArray[x][y].aliveCell()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}