//
//  RestoranlarTableViewCell.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import UIKit
import AlamofireImage

class RestoranlarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgRestoran : UIImageView!
    @IBOutlet weak var imgIsaret : UIImageView!
    @IBOutlet weak var lblRestoranAdi : UILabel!
    @IBOutlet weak var lblKonum : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgRestoran.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func gorunumAyarla(restoran : RestoranListViewModel) {
        imgRestoran.af.setImage(withURL: restoran.goruntuUrl)
        lblRestoranAdi.text = restoran.isYeriAdi
        lblKonum.text = restoran.uzaklik
    }

}
