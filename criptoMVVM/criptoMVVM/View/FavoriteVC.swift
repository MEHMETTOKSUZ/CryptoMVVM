//
//  FavoriteVC.swift
//  criptoMVVM
//
//  Created by Mehmet ÖKSÜZ on 29.10.2023.
//

import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.didFinishLoad = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
        tableView.reloadData()
    }
}

extension FavoriteVC: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 40
        cell.backgroundColor = .systemGray6
        let viewModel = viewModel.item(at: indexPath.row)
        cell.configure(response: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let deleteCrypto = viewModel.item(at: indexPath.row)
            FavoriteManager.shared.removeFvorites(cryptos: deleteCrypto.data)
            viewModel.favorites.remove(at: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name("reloadTableView"), object: nil)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
