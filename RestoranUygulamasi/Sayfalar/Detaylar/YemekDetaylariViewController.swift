//
//  YemekDetaylariViewController.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import UIKit
import MapKit
import CoreLocation

class YemekDetaylariViewController: UIViewController {
    
    @IBOutlet weak var yemekDetaylariView : YemekDetaylariView!
    var delegate : YorumlariGetirProtocol?
    
    var restoranDetaylari : DetailsView? {
        didSet {
            gorunumAyarla()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yemekDetaylariView.collectionView.register(YemekDetaylariCollectionViewCell.self, forCellWithReuseIdentifier: "MekanGoruntu")
        yemekDetaylariView.collectionView.delegate = self
        yemekDetaylariView.collectionView.dataSource = self
    }
    
    func gorunumAyarla() {
        self.title = restoranDetaylari?.mekanAdi
        
        yemekDetaylariView.lblPuan.text = restoranDetaylari?.puan
        yemekDetaylariView.lblSaat.text = restoranDetaylari?.kapaliMi
        yemekDetaylariView.lblFiyat.text = restoranDetaylari?.ucret
        yemekDetaylariView.lblKonum.text = restoranDetaylari?.telefonNumarasi
        
        yemekDetaylariView.collectionView.reloadData()
        yemekDetaylariView.collectionView.isPagingEnabled = true
        
        haritadaGoster()
    }
    
    func haritadaGoster() {
        if let coordinate = restoranDetaylari?.koordinatlari {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 90, longitudinalMeters: 90)
            yemekDetaylariView.mapView.setRegion(region, animated: true)
            
            let placemark = MKPointAnnotation()
            placemark.coordinate = coordinate
            placemark.title = restoranDetaylari?.mekanAdi
            yemekDetaylariView.mapView.addAnnotation(placemark)
        }
    }
    
    
    @IBAction func btnYorumlarıGosterClicked(_ sender: UIButton) {
        
        guard let yorumlarVC = storyboard?.instantiateViewController(identifier: "YorumlarVC") as? YorumlarTableViewController else { return }
        
        navigationController?.pushViewController(yorumlarVC, animated: true)
        
        delegate?.getir(viewController: yorumlarVC, mekanId: restoranDetaylari!.id)
        
    }
    
}

protocol YorumlariGetirProtocol {
    func getir(viewController: UIViewController, mekanId: String)
}

extension YemekDetaylariViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restoranDetaylari?.restoranGoruntuleri.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MekanGoruntu", for: indexPath) as! YemekDetaylariCollectionViewCell
        if let goruntuUrl = restoranDetaylari?.restoranGoruntuleri[indexPath.row] {
            cell.imgMekan.af.setImage(withURL: goruntuUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        yemekDetaylariView.pageControl.currentPage = indexPath.row
    }
    
}
