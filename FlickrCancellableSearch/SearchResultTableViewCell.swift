//
//  SearchResultTableViewCell.swift
//  FlickrCancellableSearch
//
//  Created by Anil Saini on 04/07/18.
//  Copyright © 2018 Anil Saini. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var flickrTitle: UILabel!
    @IBOutlet weak var flickrImage: UIImageView!
    
    func initWithPhoto(flickrPhoto: FlickrPhoto) {
        self.flickrTitle.text = flickrPhoto.title
        let url = flickrPhoto.photoUrl
        self.flickrImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .allowInvalidSSLCertificates, completed: nil)
    }

}
