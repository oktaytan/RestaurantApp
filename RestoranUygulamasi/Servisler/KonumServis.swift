//
//  KonumServis.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import Foundation
import CoreLocation


enum Sonuc<K> {
    case basarili(K)
    case hatali(Error)
}


final class KonumServis : NSObject {
    
    private let manager : CLLocationManager
    
    init(manager : CLLocationManager = .init()) {
        self.manager = manager
        self.manager.startUpdatingLocation()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        self.manager.delegate = self
        // Konum bizim belirlediğimiz distance değerinden almaya başla - sürekli alma
        self.manager.distanceFilter = CLLocationDistance(exactly: 250)!
    }
    
    var gecerliKonum : CLLocationCoordinate2D?
    var yeniKonum : ((Sonuc<CLLocation>) -> Void)?
    var konumDegisikligi : ((Bool) -> Void)?
    
    var durum : CLAuthorizationStatus {
        return manager.authorizationStatus
    }
    
    func izinIste() {
        manager.requestWhenInUseAuthorization()
    }
    
    func konumAl() {
        manager.requestLocation()
    }
}

extension KonumServis : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        yeniKonum?(.hatali(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Tüm konumları zamana göre sıralayıp bu arrayin ilk indexini alıcaz.
        // Böylece yeni konumu elde edeceğiz
        if let konum = locations.sorted(by: { $0.timestamp > $1.timestamp }).first {
            yeniKonum?(.basarili(konum))
            gecerliKonum = konum.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .notDetermined, .restricted:
            konumDegisikligi?(false)
            break
        default:
            konumDegisikligi?(true)
        }
    }
    
}
