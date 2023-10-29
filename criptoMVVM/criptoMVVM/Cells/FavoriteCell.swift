//
//  FavoriteCell.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 29.10.2023.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(response: CryptoCell.ViewModel) {
        self.currencyLabel.text = response.currency
        self.priceLabel.text = response.price
    }
    
}
