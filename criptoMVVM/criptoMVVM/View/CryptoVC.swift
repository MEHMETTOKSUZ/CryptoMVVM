//
//  ViewController.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 24.10.2023.
//

import UIKit

class CryptoVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = CrytoViewModel()
    let favoriteViewModel = FavoriteViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = .clear
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cryptos"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        viewModel.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                FavoriteManager.shared.loadFavorites()
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        viewModel.didFinishLaodWithError = { error in
            print("Hata: \(error)")
        }
    }
    @objc func reloadData() {
        tableView.reloadData()
    }
}

extension CryptoVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! CryptoCell
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 40
        cell.backgroundColor = .systemGray6
        let viewmodel = viewModel.item(at: indexPath.row)
        cell.configure(result: viewmodel)
        
        cell.favoriteButton = {
            let favorites = self.viewModel.item(at: indexPath.row)
            FavoriteManager.shared.toggleCryptos(cryptos: favorites.data)
            cell.updateFavoriteIcon(isFavorited: favorites.isFavorited)
            
        }
        return cell
    }
}

extension CryptoVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text {
            viewModel.searchCrypto(query: query)
            tableView.reloadData()
        }
    }
}
