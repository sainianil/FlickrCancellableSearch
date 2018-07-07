//
//  FlickrDataManager.swift
//  FlickrCancellableSearch
//
//  Created by Anil Saini on 04/07/18.
//  Copyright © 2018 Anil Saini. All rights reserved.
//

import Foundation

struct FlickrDataManager {
    
    let flickrKey = "6ab5d1d2804da7f78b53fdd2d5e9b115"
    
    struct Errors {
        static let invalidAccessErrorStatusCode = 100
    }
    
    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    
    func fetchPhotosForSearchText(searchText: String, onCompletion: @escaping FlickrResponse) -> Void {
        let escapedSearchText: String = searchText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&tags=\(escapedSearchText)&per_page=25&format=json&nojsoncallback=1"
        let url: NSURL = NSURL(string: urlString)!
        _ = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(String(describing: error))")
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                
                if let statusCode = results["code"] as? Int {
                    if statusCode == Errors.invalidAccessErrorStatusCode {
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        onCompletion(invalidAccessError, nil)
                        return
                    }
                }
                
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(FlickrJSON.self, from: data!)
                print(responseModel)
                
                onCompletion(nil, responseModel.photos?.photo)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
            
        }).resume()
    }
}
