//
//  KonumViewController.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import UIKit

protocol KonumAyarlamalari {
    func izinVerdi()
}

class KonumViewController: UIViewController {
    
    @IBOutlet weak var konumView : KonumView!
    var delegate : KonumAyarlamalari?

    override func viewDidLoad() {
        super.viewDidLoad()

        konumView.izinVerdi = {
            self.delegate?.izinVerdi()
        }
        
    }

}
