//
//  ViewController.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 30.03.2023.
//

import UIKit
import Alamofire
import AlamofireImage

class AlamofireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: - Properties
    
    private let cardTable = AlamofireTableView()
    private let urlString = "https://api.magicthegathering.io/v1/cards"
    private var cards: [Card] = []
    private var buttonSearchPressed = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboard()
        getData(urlString: urlString)
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view = cardTable
        cardTable.searchTextField.delegate = self
        cardTable.cardTableView.dataSource = self
        cardTable.cardTableView.delegate = self
        cardTable.searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        cardTable.resetButton.addTarget(self, action: #selector(resetButtonPressed(_:)), for: .touchUpInside)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cardDetailsViewController = AlamofireCardDetailsViewController()
        cardDetailsViewController.card = cards[indexPath.row]
        present(cardDetailsViewController, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - API
    
    /// Method for request from network
    func getData(urlString: String) {
        AF.request(urlString).responseDecodable(of: CardsResponse.self) { [weak self] response in
            switch response.result {
            case .success(let cardsResponse):
                if self?.buttonSearchPressed == true {
                    self?.cards = cardsResponse.cards.filter { $0.imageUrl != nil && $0.name == self?.cardTable.searchTextField.text }
                } else {
                    self?.cards = cardsResponse.cards.filter { $0.imageUrl != nil }
                }
                
                if self?.cards.isEmpty == true, self?.buttonSearchPressed == true {
                    self?.errorAlert(error: AFError.responseValidationFailed(reason: .dataFileNil), response: response.response, customMessage: "No cards found with the provided name.")
                } else {
                    self?.preloadImages(completion: {
                        DispatchQueue.main.async {
                            self?.cardTable.cardTableView.reloadData()
                        }
                    })
                }
            case .failure(let error):
                self?.errorAlert(error: error, response: response.response)
            }
        }
    }
    
    /// Method for errors
    func errorAlert(error: AFError, response: HTTPURLResponse?, customMessage: String? = nil) {
        var errorMessage = "Search failed"
        
        if let statusCode = response?.statusCode {
            errorMessage += "\nHTTP status cod: \(statusCode)"
        }
        
        if let underlyingError = error.asAFError?.underlyingError {
            errorMessage += "\nDetailed error: \(underlyingError.localizedDescription)"
        }
        
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    /// Method for hide keyboard
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Method loads cards images asynchronously and executes the given block of code after all downloads are completed
    func preloadImages(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        for card in cards {
            if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
                let temporaryImageView = UIImageView()
                dispatchGroup.enter()
                temporaryImageView.af.setImage(withURL: url, completion: { _ in
                    dispatchGroup.leave()
                })
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
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
        
        buttonSearchPressed = true
        let searchUrlString = "https://api.magicthegathering.io/v1/cards?name=\(encodedQuery)"
        getData(urlString: searchUrlString)
    }
    
    @objc func resetButtonPressed(_ sender: UIButton) {
        cardTable.searchTextField.text = ""
        buttonSearchPressed = false
        getData(urlString: urlString)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

