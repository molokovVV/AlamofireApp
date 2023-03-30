//
//  AlamofireTableViewCell.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 30.03.2023.
//

import UIKit

class AlamofireTableViewCell: UITableViewCell {
    
    //MARK: - UI Elements
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(nameLabel)
        addSubview(typeLabel)
        addSubview(cardImageView)
    }
    
    private func setupLayout() {
        cardImageView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(8)
                make.width.equalTo(cardImageView.snp.height).multipliedBy(0.75)
                make.height.equalTo(150) 
                make.bottom.lessThanOrEqualToSuperview().inset(8) 
            }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(cardImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
}
