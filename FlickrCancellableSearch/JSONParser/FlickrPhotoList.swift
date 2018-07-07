//
//  FlickrPhotoList.swift
//  FlickrCancellableSearch
//
//  Created by Anil Saini on 04/07/18.
//  Copyright © 2018 Anil Saini. All rights reserved.
//

import Foundation
struct FlickrPhotoList : Codable {
    let page : Int?
    let pages : Int?
    let perpage : Int?
    let total : String?
    let photo : [FlickrPhoto]?
    
    enum CodingKeys: String, CodingKey {
        
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case total = "total"
        case photo = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        perpage = try values.decodeIfPresent(Int.self, forKey: .perpage)
        total = try values.decodeIfPresent(String.self, forKey: .total)
        photo = try values.decodeIfPresent([FlickrPhoto].self, forKey: .photo)
    }
    
}
