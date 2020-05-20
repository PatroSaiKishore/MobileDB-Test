//
//  APIManager.swift
//  Test-MovieApp
//
//  Created by saikishore on 18/05/20.
//  Copyright © 2020 saikishore. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    
    static let shared =  APIManager()
    var count = 0
    
    func APIRequ(url: String, dataDisplay:  [DataToShow], collection: UICollectionView) {
        var dataTask = URLSessionDataTask()
        var toDisplay = dataDisplay
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            
            if data != nil {
                
                do {
                    if  let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        
                        if let array = jsonData["results"] as? NSArray {
                            for each in 0..<array.count {
                                if let description = array[each] as? NSDictionary {
                                    toDisplay.append(DataToShow(title: "\(description["title"])", description: "\(description["overview"])", imagePath: "\(description["poster_path"])", dates: "\(description["dates"])"))
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            collection.reloadData()
                        }
                    }
                } catch {
                    fatalError()
                }
            }
        })
        dataTask.resume()
    }
}
