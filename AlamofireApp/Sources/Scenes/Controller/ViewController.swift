//
//  ViewController.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 30.03.2023.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    
    private let cardTable = AlamofireTableView()
    private var cards: [Card] = []
    
    //MARK: - Lifecycle
    
    override func loadView() {
        view = cardTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTable.cardTableView.dataSource = self
        cardTable.cardTableView.delegate = self
        cardTable.searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        
        getData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlamofireTableViewCell", for: indexPath) as! AlamofireTableViewCell
        let card = cards[indexPath.row]
        cell.nameLabel.text = card.name ?? "Название отсутствует"
        cell.typeLabel.text = card.type ?? "Тип отсутствует"
        
        if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
                print("Image URL: \(url)")
            cell.cardImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.cardImageView.image = UIImage(named: "placeholder")
            }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - API

    func getData() {
        let urlString = "https://api.magicthegathering.io/v1/cards"
        AF.request(urlString).responseDecodable(of: CardsResponse.self) { [weak self] response in
            switch response.result {
            case .success(let cardsResponse):
                self?.cards = cardsResponse.cards
                self?.cardTable.cardTableView.reloadData()
            case .failure(let error):
                print("Error fetching cards: \(error)")
            }
        }
    }
    
    
    //MARK: - Actions
    
    @objc func searchButtonPressed(_ sender: UIButton) {
        guard let query = cardTable.searchTextField.text, !query.isEmpty else {
            return
        }

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding query: \(query)")
            return
        }
        
        let urlString = "https://api.magicthegathering.io/v1/cards?name=\(encodedQuery)"
        AF.request(urlString).responseDecodable(of: CardsResponse.self) { [weak self] response in
            switch response.result {
            case .success(let cardsResponse):
                self?.cards = cardsResponse.cards
                self?.cardTable.cardTableView.reloadData()
            case .failure(let error):
                print("Error fetching cards: \(error)")
                var errorMessage = "Не удалось выполнить поиск"
                
                if let statusCode = response.response?.statusCode {
                    errorMessage += "\nHTTP статус код: \(statusCode)"
                }
                
                if let underlyingError = error.asAFError?.underlyingError {
                    errorMessage += "\nПодробная ошибка: \(underlyingError.localizedDescription)"
                }
                
                let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alertController, animated: true)
            }
        }
    }
}

