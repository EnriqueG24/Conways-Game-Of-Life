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
}
