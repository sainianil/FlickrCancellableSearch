//
//  FlickrPhoto.swift
//  FlickrCancellableSearch
//
//  Created by Anil Saini on 04/07/18.
//  Copyright © 2018 Anil Saini. All rights reserved.
//

import Foundation

struct FlickrPhoto : Codable {
    let id : String?
    let owner : String?
    let secret : String?
    let server : String?
    let farm : Int?
    let title : String?
    let ispublic : Int?
    let isfriend : Int?
    let isfamily : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
        case ispublic = "ispublic"
        case isfriend = "isfriend"
        case isfamily = "isfamily"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        owner = try values.decodeIfPresent(String.self, forKey: .owner)
        secret = try values.decodeIfPresent(String.self, forKey: .secret)
        server = try values.decodeIfPresent(String.self, forKey: .server)
        farm = try values.decodeIfPresent(Int.self, forKey: .farm)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        ispublic = try values.decodeIfPresent(Int.self, forKey: .ispublic)
        isfriend = try values.decodeIfPresent(Int.self, forKey: .isfriend)
        isfamily = try values.decodeIfPresent(Int.self, forKey: .isfamily)
    }
    
    var photoUrl: URL {
        var url = URL(string: "")
        if let farm = self.farm,
            let server = self.server,
            let id = self.id,
            let secret = self.secret {
            url = URL(string: "https://farm\(String(describing: farm)).staticflickr.com/\(String(describing: server))/\(String(describing: id))_\(String(describing: secret))_m.jpg")!
        }
        return url!
    }
    
}
