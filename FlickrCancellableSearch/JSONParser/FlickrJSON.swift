//
//  Flickr.swift
//  FlickrCancellableSearch
//
//  Created by Anil Saini on 04/07/18.
//  Copyright © 2018 Anil Saini. All rights reserved.
//

import Foundation

struct FlickrJSON : Codable {
    let photos : FlickrPhotoList?
    let stat : String?
    
    enum CodingKeys: String, CodingKey {
        
        case photos = "photos"
        case stat = "stat"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decodeIfPresent(FlickrPhotoList.self, forKey: .photos)
        stat = try values.decodeIfPresent(String.self, forKey: .stat)
    }
    
}
