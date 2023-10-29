//
//  FavoriteManger.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 29.10.2023.
//

import Foundation

class FavoriteManager {
    
    static let shared = FavoriteManager()
    private init() {}
    private let userDefaults = UserDefaults.standard
    private let favoriteKeys = "FavoriteCryptos"
    
    var favorite: [Crypto] = []
    
    func toggleCryptos(cryptos: Crypto) {
        if let index = favorite.firstIndex(where: { $0.currency == cryptos.currency }) {
            favorite.remove(at: index)
        } else {
            favorite.append(cryptos)
        }
        savedFavorites()
        NotificationCenter.default.post(name: Notification.Name("FavoriteRemoved"), object: nil, userInfo: ["removedCrypto": cryptos])
        
        
    }
    
    func removeFvorites(cryptos: Crypto) {
        if let index = favorite.firstIndex(where: { $0.currency == cryptos.currency}) {
            favorite.remove(at: index)
            savedFavorites()
        }
    }
    
    func isMovieFavorite(_ crypto: Crypto) -> Bool {
        return favorite.contains { $0.currency == crypto
                .currency
        }
    }
    
    func loadFavorites() {
        if let data = userDefaults.data(forKey: favoriteKeys),
           let favorites = try? JSONDecoder().decode([Crypto].self, from: data) {
            self.favorite = favorites
        }
    }
    
    func savedFavorites() {
        if let encodeData = try? JSONEncoder().encode(favorite) {
            userDefaults.set(encodeData, forKey: favoriteKeys)
        }
    }
}
