//
//  FavoriteViewModel.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 29.10.2023.
//

import Foundation


class FavoriteViewModel {
    
    var favorites: [CryptoCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var numberOfInSection: Int {
        return favorites.count
    }
    
    func item(at index: Int) -> CryptoCell.ViewModel {
        return favorites[index]
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.object(forKey: "FavoriteCryptos") as? Data ,
           let favorites = try? JSONDecoder().decode([Crypto].self, from: data) {
            self.presentFavorite(result: favorites)
            self.didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("favorite can not load")
        }
    }
    
    func presentFavorite(result: [Crypto]) {
        
        let viewModel: [CryptoCell.ViewModel] = result.map { result in
            CryptoCell.ViewModel(response: result)
        }
        
        self.favorites = viewModel
        self.didFinishLoad?()
    }
    
    
}
