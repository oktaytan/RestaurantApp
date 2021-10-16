//
//  RestoranlarTableViewController.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import UIKit

protocol RestoranListesiAction {
    func restoranSec(viewController: UIViewController, restoran : RestoranListViewModel)
}

class RestoranlarTableViewController: UITableViewController {
    
    var delegate : RestoranListesiAction?
    
    var restoranListesi = [RestoranListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        aramaAlanıEkle()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restoranListesi.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestoranCell", for: indexPath) as? RestoranlarTableViewCell {
            
            let restoran = restoranListesi[indexPath.row]
            cell.gorunumAyarla(restoran: restoran)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detaylarVC = storyboard?.instantiateViewController(identifier: "DetaylarVC") else { return }
        navigationController?.pushViewController(detaylarVC, animated: true)
        self.delegate?.restoranSec(viewController: detaylarVC, restoran: restoranListesi[indexPath.row])
    }
    
    func aramaAlanıEkle() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
}

extension RestoranlarTableViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let aramaIfadesi = searchBar.text {
            let notification = Notification(name: Notification.Name("RestoranArama"), object: aramaIfadesi, userInfo: nil)
            NotificationCenter.default.post(notification)
        }
    }
}
