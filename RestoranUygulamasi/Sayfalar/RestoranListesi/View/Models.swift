//
//  Models.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 24.09.2020.
//

import Foundation
import CoreLocation

struct business : Codable {
    var id : String
    var name : String
    var imageUrl : URL
    var distance : Double
}

struct TumVeriler : Codable {
    let businesses : [business]
}

struct RestoranListViewModel {
    let id : String
    let isYeriAdi : String
    let goruntuUrl : URL
    let uzaklik : String
    
    init(yer: business) {
        self.id = yer.id
        self.isYeriAdi = yer.name
        self.goruntuUrl = yer.imageUrl
        self.uzaklik = "\(String(format: "%.2f", yer.distance / 1000))"
    }
}

struct Details : Decodable {
    let id : String
    let price : String
    let phone : String
    let rating : Double
    let name : String
    let isClosed : Bool
    let photos : [URL]
    let coordinates : CLLocationCoordinate2D
}

extension CLLocationCoordinate2D : Decodable {
    enum Keys : CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let lat = try container.decode(Double.self, forKey: .latitude)
        let long = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: lat, longitude: long)
    }
}


struct DetailsView  {
    
    let id : String
    var mekanAdi : String
    var telefonNumarasi : String
    var ucret : String
    var kapaliMi: String
    var puan : String
    var restoranGoruntuleri : [URL]
    var koordinatlari: CLLocationCoordinate2D
    
    init(details: Details){
        
        self.id = details.id
        self.mekanAdi = details.name
        self.telefonNumarasi = details.phone
        self.ucret = details.price
        self.kapaliMi = details.isClosed ? "Kapalı" : "Açık"
        self.puan = "\(details.rating)/5"
        self.restoranGoruntuleri = details.photos
        self.koordinatlari = details.coordinates
        
    }
    
}


// Kullanıcı Yorumları
struct User : Decodable {
    let imageUrl : URL
    let name : String
}

struct Review : Decodable {
    let rating : Double
    let text : String
    let user : User
}

struct Response : Decodable {
    let reviews : [Review]
}

// Türkçe Kullanıcı Yorumları Codable Yapısı
struct Kullanici : Decodable {
    let goruntuUrl : URL
    let adi : String
    
    enum CodingKeys : String, CodingKey {
        case goruntuUrl = "imageUrl"
        case adi = "name"
    }
}

struct Yorum : Decodable {
    let yorumPuani : Double
    let yorumText : String
    let kullanici : Kullanici
    
    enum CodingKeys : String, CodingKey {
        case yorumPuani = "rating"
        case yorumText = "text"
        case kullanici = "user"
    }
}

struct Cevap : Decodable {
    let yorumlar : [Yorum]
    
    enum CodingKeys : String, CodingKey {
        case yorumlar = "reviews"
    }
}
