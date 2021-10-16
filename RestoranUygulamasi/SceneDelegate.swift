//
//  SceneDelegate.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import UIKit
import Moya
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let konumServis = KonumServis()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var navigationController : UINavigationController?
    
    var aramaFiltresi : String? {
        didSet {
            if self.aramaFiltresi!.isEmpty {
                self.isYerleriniGetir(coordinate: konumServis.gecerliKonum!)
            } else {
                self.isYerleriniGetir(coordinate: konumServis.gecerliKonum!, aramaFiltre: self.aramaFiltresi!)
            }
        }
    }
    
    let decoder = JSONDecoder()
    let agServis = MoyaProvider<YelpServis.VeriSaglayici>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        konumServis.yeniKonum = { sonuc in
            switch sonuc {
            case .basarili(let konumBilgisi):
                //print(konumBilgisi.coordinate.latitude, " - ", konumBilgisi.coordinate.longitude)
                NotificationCenter.default.addObserver(self, selector: #selector(self.setFilter(notification:)), name: NSNotification.Name("RestoranArama"), object: nil)
                self.isYerleriniGetir(coordinate: konumBilgisi.coordinate)
                break
            case .hatali(let error):
                print("Hata : \(error.localizedDescription)")
            }
        }
        
        switch self.konumServis.durum {
        case .denied, .notDetermined, .restricted:
            if let konumVC = storyboard.instantiateViewController(identifier: "KonumVC") as? KonumViewController {
                konumVC.delegate = self
                self.window?.rootViewController = konumVC
                break
            }
        default:
            if let navigation = storyboard.instantiateViewController(identifier: "RestoranNavigationVC") as? UINavigationController {
                self.window?.rootViewController = navigation
                navigationController = navigation
                konumServis.konumAl()
                (navigation.topViewController as? RestoranlarTableViewController)?.delegate = self
            }
        }
        
        window?.makeKeyAndVisible()
        
    }
    
    @objc func setFilter(notification: Notification) {
        if let aramaFiltresi = notification.object as? String {
            self.aramaFiltresi = aramaFiltresi
        }
    }
    
    private func detaylariGetir(viewController: UIViewController, mekanId: String) {
        agServis.request(.details(id: mekanId)) { (response) in
            switch response {
            case .success(let veri):
                if let detaylar = try? self.decoder.decode(Details.self, from: veri.data) {
                    // Detaylar aktarılacak
                    let restoranDetaylari = DetailsView(details: detaylar)
                    let yemekDetaylariVC = (viewController as? YemekDetaylariViewController)
                    yemekDetaylariVC?.restoranDetaylari = restoranDetaylari
                    yemekDetaylariVC?.delegate = self
                }
            case .failure(let hata):
                print("Hata : \(hata)")
            }
        }
    }
    
    func isYerleriniGetir(coordinate: CLLocationCoordinate2D) {
        
        agServis.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { (response) in
            switch response {
            case .success(let gelenVeri):
                
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                let veri = try! self.decoder.decode(TumVeriler.self, from: gelenVeri.data)
                let restoranListesi = veri.businesses.compactMap(RestoranListViewModel.init).sorted(by: { $0.uzaklik < $1.uzaklik })
                
                if let navigation = self.window?.rootViewController as? UINavigationController, let restoranlarTableViewController = navigation.topViewController as? RestoranlarTableViewController {
                    restoranlarTableViewController.restoranListesi = restoranListesi
                } else if let navigation1 = self.storyboard.instantiateViewController(identifier: "RestoranNavigationVC") as? UINavigationController {
                    self.navigationController = navigation1
                    self.window?.rootViewController?.present(navigation1, animated: true, completion: {
                        (navigation1.topViewController as? RestoranlarTableViewController)?.delegate = self
                        (navigation1.topViewController as? RestoranlarTableViewController)?.restoranListesi = restoranListesi
                    })
                }
                break
            case .failure(let hata):
                print("Hata meydana geldi : \(hata.localizedDescription)")
                break
            }
        }
    }
    
    func isYerleriniGetir(coordinate: CLLocationCoordinate2D, aramaFiltre: String) {
        
        agServis.request(.searchFilter(lat: coordinate.latitude, long: coordinate.longitude, filter: aramaFiltre)) { (response) in
            switch response {
            case .success(let gelenVeri):
                
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                let veri = try! self.decoder.decode(TumVeriler.self, from: gelenVeri.data)
                let restoranListesi = veri.businesses.compactMap(RestoranListViewModel.init).sorted(by: { $0.uzaklik < $1.uzaklik })
                
                if let navigation = self.window?.rootViewController as? UINavigationController, let restoranlarTableViewController = navigation.topViewController as? RestoranlarTableViewController {
                    restoranlarTableViewController.restoranListesi = restoranListesi
                } else if let navigation1 = self.storyboard.instantiateViewController(identifier: "RestoranNavigationVC") as? UINavigationController {
                    self.navigationController = navigation1
                    self.window?.rootViewController?.present(navigation1, animated: true, completion: {
                        (navigation1.topViewController as? RestoranlarTableViewController)?.delegate = self
                        (navigation1.topViewController as? RestoranlarTableViewController)?.restoranListesi = restoranListesi
                    })
                }
                break
            case .failure(let hata):
                print("Hata meydana geldi : \(hata.localizedDescription)")
                break
            }
        }
    }
    
    func yorumalarıGetir(viewController: UIViewController, mekanId: String) {
        print("Mkan ID: \(mekanId)")
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        agServis.request(.reviews(id: mekanId)) { (result) in
            switch result {
            case .success(let veri):
            if let yorumlar = try? self.decoder.decode(Cevap.self, from: veri.data) {
                (viewController as? YorumlarTableViewController)?.yorumlar = yorumlar.yorumlar
            }
            break
            case .failure(let error):
                print("Hata : \(error.localizedDescription)")
                break
            }
        }
    }
}


extension SceneDelegate : KonumAyarlamalari, RestoranListesiAction, YorumlariGetirProtocol {
    
    func izinVerdi() {
        konumServis.izinIste()
    }
    
    func restoranSec(viewController: UIViewController, restoran: RestoranListViewModel) {
        detaylariGetir(viewController: viewController, mekanId: restoran.id)
    }
    
    func getir(viewController: UIViewController, mekanId: String) {
        self.yorumalarıGetir(viewController: viewController, mekanId: mekanId)
    }
}
