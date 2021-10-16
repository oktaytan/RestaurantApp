//
//  AgServis.swift
//  RestoranUygulamasi
//
//  Created by Oktay Tanrıkulu on 23.09.2020.
//

import Foundation
import Moya

private let apiKey = "{YOUR_API_KEY_OF_YELP_API}"

enum YelpServis {
    
    enum VeriSaglayici : TargetType {
        
        case search(lat: Double, long: Double)
        case searchFilter(lat: Double, long: Double, filter: String)
        case details(id: String)
        case reviews(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search : return "/search"
            case .details(let id) : return "/\(id)"
            case .searchFilter : return "/search"
            case .reviews(let id) : return "/\(id)/reviews"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(parameters: ["latitude": lat, "longitude": long, "limit": 20], encoding: URLEncoding.queryString)
            case let .searchFilter(lat, long, filter):
                return .requestParameters(parameters: ["latitude": lat, "longitude": long, "limit": 20, "term": filter, "radius": 40000], encoding: URLEncoding.queryString)
            case .details(_): return .requestPlain
            case .reviews(_): return .requestPlain
            }
        }
        
        var headers: [String : String]? {
            return ["Authorization" : "Bearer \(apiKey)"]
        }
        
    }
    
}
