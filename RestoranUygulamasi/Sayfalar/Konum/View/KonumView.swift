//
//  KonumView.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import UIKit

@IBDesignable class KonumView: TemelView {

    @IBOutlet weak var btnIzinVer : UIButton!
    @IBOutlet weak var btnReddet : UIButton!
    
    var izinVerdi : (() -> Void)?

    @IBAction func btnIzinVerClicked(_ sender : UIButton) {
        izinVerdi?()
    }
    
    @IBAction func btnReddetClicked(_ sender : UIButton) {
        
    }
}
