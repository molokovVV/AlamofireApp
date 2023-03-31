//
//  AlamofireCardDetailsViewController.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 31.03.2023.
//

import UIKit
import AlamofireImage

class AlamofireCardDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var card: Card?
    
    // MARK: - UI Elements
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        configureCardDetails()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(nameLabel)
        view.addSubview(cardImageView)
        view.addSubview(typeLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func setupLayout() {
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(400)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    /// Method for setup modal window
    private func configureCardDetails() {
        if let card = card {
            nameLabel.text = card.name
            typeLabel.text = card.type
            descriptionLabel.text = card.description
            
            if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
                cardImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"))
            }
        } 
    }
}
