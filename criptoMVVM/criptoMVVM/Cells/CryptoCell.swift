//
//  cryptoCell.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 24.10.2023.
//

import UIKit

class CryptoCell: UITableViewCell {
    
    struct ViewModel {
        
        let currency: String
        let price: String
        let data: Crypto
        
        var isFavorited: Bool {
            FavoriteManager.shared.isMovieFavorite(data)
        }
    }
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    var favoriteButton: (() ->Void)?
    
    func configure(result: ViewModel) {
        self.currencyLabel.text = result.currency.uppercased()
        self.priceLabel.text = result.price
        let imageName : String = result.isFavorited ? "star.fill": "star"
        self.favoriteButtonOutlet.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func updateFavoriteIcon(isFavorited: Bool) {
        let imageName: String = isFavorited ? "star.fill" : "star"
        favoriteButtonOutlet.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        self.favoriteButton?()
    }
}

extension CryptoCell.ViewModel {
    init(response: Crypto) {
        
        self.init(currency: response.currency,
                  price: response.price,
                  data: response)
    }
}
