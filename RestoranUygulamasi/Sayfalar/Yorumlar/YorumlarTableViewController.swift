//
//  YorumlarTableViewController.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 24.09.2020.
//

import UIKit

class YorumlarTableViewController: UITableViewController {
    
    var yorumlar : [Yorum]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yorumlar?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "YorumCell", for: indexPath) as? YorumlarTableViewCell {
            if let yorumlar = yorumlar {
                let yorum = yorumlar[indexPath.row]
                
                cell.lblAdi.text = yorum.kullanici.adi
                cell.lblPuani.text = "Puanı : \(yorum.yorumPuani) / 5"
                cell.lblYorum.text = yorum.yorumText
                cell.imgKullanici.af.setImage(withURL: yorum.kullanici.goruntuUrl)
                cell.imgKullanici.layer.cornerRadius = 10
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
