//
//  ViewModel.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 24.10.2023.
//

import Foundation

class CrytoViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishLaodWithError: ((String) -> Void)?
    var cryptos: [CryptoCell.ViewModel] = []
    var filteredCryptos: [CryptoCell.ViewModel] = []
    var isSearching: Bool = false
    
    var numberOfInSection: Int {
        return isSearching ? filteredCryptos.count : cryptos.count
    }
    
    func item(at index: Int) -> CryptoCell.ViewModel {
        return isSearching ? filteredCryptos[index] : cryptos[index]
    }
    
    func fetchData() {
        
        guard let urlString = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json") else {
            return
        }
        
        WebService().getData(from: urlString) { (result: Result<[Crypto], Error>) in
            switch result {
            case .success(let data):
                self.presentResult(result: data)
            case .failure(let error):
                self.didFinishLaodWithError?(error.localizedDescription)
                
            }
        }
    }
    
    
    func presentResult(result: [Crypto]) {
        
        let viewModel: [CryptoCell.ViewModel] = result.map { results in
            CryptoCell.ViewModel(response: results)
        }
        
        self.cryptos = viewModel
        didFinishLoad?()
    }
    
    func searchCrypto(query: String) {
        isSearching = !query.isEmpty
        
        if isSearching {
            filteredCryptos = cryptos.filter { crypto in
                return crypto.currency.lowercased().contains(query.lowercased())
            }
        }
        
        didFinishLoad?()
    }
}
