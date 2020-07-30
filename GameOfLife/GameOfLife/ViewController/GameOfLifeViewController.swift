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
    var settingsVC: SettingsViewController!
    let presetView = UIView()
    
    // MARK: - IBOutlets
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: UIBarButtonItem) {
        if isRunning == false {
            isRunning = true
            sender.image = UIImage(systemName: "pause.circle")
            nextBtn.isEnabled = false
        } else {
            isRunning = false
            sender.image = UIImage(systemName: "play.circle")
            nextBtn.isEnabled = true
        }
        grid.configureTimer()
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        present(settingsVC, animated: true)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIBarButtonItem) {
        grid.resetGame()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        if isRunning == false {
            grid.computeNext()
            grid.generations += 1
        }
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradient()
        grid = Grid(width: self.view.frame.width, height: self.view.frame.height, view: self.view)
        settingsVC = SettingsViewController(grid: grid)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle), name: Notification.Name("generationChanged"), object: nil)
        configurePresetBar()
        setupPreset()
        setupTableView()
        configureCurrentPresetLabel()
        configurePresets()
        configureCurrentPresetView(index: 0)
    }
    
    // MARK: - Methods
    func configurePresets() {
        grid.presets.append(ShapePresets(size: 1, cellWidth: grid.cellSize, toolPalette: .dot))
        grid.presets.append(ShapePresets(size: 2, cellWidth: grid.cellSize, toolPalette: .block))
        grid.presets.append(ShapePresets(size: 3, cellWidth: grid.cellSize, toolPalette: .blinker))
        grid.presets.append(ShapePresets(size: 3, cellWidth: grid.cellSize, toolPalette: .glider))
        grid.presets.append(ShapePresets(size: 3, cellWidth: grid.cellSize, toolPalette: .rectangle))
        grid.presets.append(ShapePresets(size: 3, cellWidth: grid.cellSize, toolPalette: .tub))
        grid.presets.append(ShapePresets(size: 4, cellWidth: grid.cellSize, toolPalette: .beacon))
        grid.presets.append(ShapePresets(size: 4, cellWidth: grid.cellSize, toolPalette: .beehive))
    }
    
    func configurePresetBar() {
        presetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presetView)
        presetView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            presetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            presetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            presetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presetView.topAnchor.constraint(equalTo: grid.screenArray[24][24].bottomAnchor)
        ])
    }
    
    func configureCurrentPresetLabel() {
        label.text = "Current Tool: Dot"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func configureCurrentPresetView(index: Int) {
        if grid.currentPreset != nil { grid.currentPreset.removeFromSuperview() }
        let selectedPreset = grid.presets[index]
        let preset = ShapePresets(size: selectedPreset.size, cellWidth: selectedPreset.cellWidth, toolPalette: selectedPreset.currentTool)
        grid.currentPreset = preset
        preset.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(preset)
        NSLayoutConstraint.activate([
            preset.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            preset.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -preset.frame.width / 2)
        ])
        label.text = "Current Tool: " + grid.currentPreset.currentTool.rawValue.capitalized
    }
    
    func backgroundGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        view.layer.addSublayer(layer)
    }
    
    func setupPreset() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        self.presetTableView = tableView
        NSLayoutConstraint.activate([
            self.presetView.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.presetView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.presetView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.presetView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
    }
    
    func setupTableView() {
        self.presetTableView.dataSource = self
        self.presetTableView.delegate = self
        self.presetTableView.allowsSelection = true
        self.presetTableView.register(PresetTableViewCell.self, forCellReuseIdentifier: "PresetCell")
        presetTableView.backgroundColor = .clear
    }
    
    // MARK: - Objective-C Methods
    @objc func updateTitle(_ notification: NSNotification) {
        if let dict = notification.userInfo {
            if let id = dict["generations"] as? Int {
                if id == 0{
                    title = "Game of Life"
                } else {
                    title = "\(id) Generations"
                }
            }
        }
    }
}


// MARK: - Extension
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
