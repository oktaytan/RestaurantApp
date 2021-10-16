//
//  YorumlarTableViewCell.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 24.09.2020.
//

import UIKit

class YorumlarTableViewCell: UITableViewCell {

    @IBOutlet weak var lblYorum: UILabel!
    @IBOutlet weak var lblPuani: UILabel!
    @IBOutlet weak var lblAdi: UILabel!
    @IBOutlet weak var imgKullanici: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
