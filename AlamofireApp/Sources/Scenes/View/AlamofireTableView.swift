//
//  AlamofireTableView.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 30.03.2023.
//

import UIKit
import AlamofireImage

class AlamofireTableView: UIView {
    
    // MARK: - UI Elements
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.tintColor = .black
        textField.placeholder = "Введите название карты"
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Поиск", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 17
        button.backgroundColor = .black
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сбросить", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    lazy var cardTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlamofireTableViewCell.self, forCellReuseIdentifier: "AlamofireTableViewCell")
        return tableView
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setups
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        addSubview(searchTextField)
        addSubview(cardTableView)
        addSubview(buttonsStackView)
        
    }
    
    private func setupLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        cardTableView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        buttonsStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.width.equalTo(300)
        }
    }
}
