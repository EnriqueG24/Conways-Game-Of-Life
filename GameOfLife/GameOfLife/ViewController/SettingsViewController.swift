//
//  SettingsViewController.swift
//  GameOfLife
//
//  Created by Enrique Gongora on 7/28/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    var grid: Grid!
    var speedSlider = UISlider()
    var stackView = UIStackView()
    var exitButton = UIButton()
    var cellColorButtons = [UIButton]()
    let label = UILabel()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Init
    init(grid: Grid) {
        super.init(nibName: nil, bundle:  nil)
        self.grid = grid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configureStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        configureStackViewConstraints()
        stackView.distribution = .fillEqually
        
        for i in 1...5 {
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(colorChanged(sender:)), for: .touchUpInside)
            switch i {
            case 1:
                button.backgroundColor = .systemGreen
            case 2:
                button.backgroundColor = .systemBlue
            case 3:
                button.backgroundColor = .systemRed
            case 4:
                button.backgroundColor = .black
            case 5:
                button.backgroundColor = .systemBackground
                button.setImage(UIImage(systemName: "shuffle"), for: .normal)
            default:
                button.backgroundColor = .black
            }
            cellColorButtons.append(button)
            stackView.addArrangedSubview(button)
            if i == Settings.shared.cellColor.rawValue {
                colorChanged(sender: button)
            }
        }
    }
    
    private func configureSpeedSlider() {
        view.addSubview(speedSlider)
        speedSlider.minimumValue = 0.03
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1
        speedSlider.addTarget(self, action: #selector(speedsliderChanged), for: .valueChanged)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "\(1.0 / speedSlider.value) generations per second"
        label.textColor = .white
        NSLayoutConstraint.activate([
            speedSlider.topAnchor.constraint(equalTo: exitButton.topAnchor, constant: 200),
            speedSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            speedSlider.heightAnchor.constraint(equalToConstant: 20),
            label.bottomAnchor.constraint(equalTo: speedSlider.topAnchor, constant: -20)
        ])
    }
    
    private func configureExitButton() {
        view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        exitButton.setTitle("Dismiss", for: .normal)
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: 100),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupViews() {
        view.translatesAutoresizingMaskIntoConstraints = false
        speedSlider.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.50)
        configureExitButton()
        configureSpeedSlider()
        configureStackView()
    }
    
    // MARK: - Objective-C Methods
    @objc func colorChanged(sender: UIButton) {
        guard let color = CellColor.init(rawValue: sender.tag) else { return }
        Settings.shared.cellColor = color
        for button in cellColorButtons {
            button.layer.borderWidth = 0
            if Settings.shared.cellColor.rawValue == button.tag {
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.yellow.cgColor
            }
        }
    }
    
    @objc func speedsliderChanged(){
        grid?.speed = speedSlider.value
        label.text = "\(1.0 / speedSlider.value) generations per second"
    }
    
    @objc func exitButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
