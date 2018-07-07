//
//  SearchViewController.swift
//  FlickrCancellableSearch
//
//  Created by Anil Saini on 04/07/18.
//  Copyright © 2018 Anil Saini. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, SearchControllerDelegate, UISearchBarDelegate {
    
    var searchQueue: OperationQueue = OperationQueue()
    var searchResult: [FlickrPhoto] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchPhotosForSearchText(searchText: "test")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cancelSearch()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchDisplayController(controller: self, searchText: searchBar.text!)
    }
    
    
    // MARK: - Private
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Flickr Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchResult.count)
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath as IndexPath) as? SearchResultTableViewCell
        cell!.initWithPhoto(flickrPhoto: searchResult[indexPath.row])
        return cell!
    }
}

protocol SearchControllerDelegate: class {
    
    var searchQueue:OperationQueue {get set}
    
    var searchResult:[FlickrPhoto] {get set}
    
    func searchDisplayController(controller:SearchViewController, searchText:String)
    
    func cancelSearch()
}

extension SearchViewController {
    
    func searchDisplayController(controller:SearchViewController, searchText:String) {
        guard !searchText.isEmpty else {
            self.searchResult.removeAll()
            return
        }
        
        self.searchQueue.cancelAllOperations()
        self.searchQueue.addOperation  { [weak self] in
            DispatchQueue.main.async(execute: { () -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            FlickrDataManager().fetchPhotosForSearchText(searchText: searchText, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
                if error == nil {
                    self?.searchResult = flickrPhotos!
                } else {
                    self?.searchResult = []
                    if (error!.code == FlickrDataManager.Errors.invalidAccessErrorStatusCode) {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self?.showErrorAlert()
                        })
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self?.title = searchText
                    self?.tableView.reloadData()
                })
            })
        }
    }
    
    func cancelSearch() {
        self.searchQueue.cancelAllOperations()
        self.searchResult.removeAll()
        self.title = ""
    }
}
