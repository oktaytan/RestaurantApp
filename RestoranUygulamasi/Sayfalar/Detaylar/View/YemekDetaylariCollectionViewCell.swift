//
//  YemekDetaylariCollectionViewCell.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 24.09.2020.
//

import UIKit

class YemekDetaylariCollectionViewCell: UICollectionViewCell {
    
    let imgMekan = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ayarla()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Hata meydana geldi")
    }
    
    func ayarla() {
        contentView.addSubview(imgMekan)
        imgMekan.translatesAutoresizingMaskIntoConstraints = false
        imgMekan.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            imgMekan.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgMekan.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgMekan.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgMekan.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
}
