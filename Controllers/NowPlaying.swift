//
//  NowPlaying.swift
//  Test-MovieApp
//
//  Created by saikishore on 18/05/20.
//  Copyright © 2020 saikishore. All rights reserved.
//

import UIKit
import Alamofire

class NowPlaying: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var search: UISearchBar!
    
    var initialDataToshow = [DataToShow]()
    var searchData = [DataToShow]()
    var searchBegins = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequest()
        collectionView.register(UINib(nibName: "Cells", bundle: Bundle.main), forCellWithReuseIdentifier: "Cells")
        collectionLayout.scrollDirection = .vertical
        search.delegate = self
        collectionView.reloadData()
    }
    
    func APIRequest() {
        
        var dataTask = URLSessionDataTask()
        let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            
            if data != nil {
                
                do {
                    if  let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        
                        
                        if let array = jsonData["results"] as? NSArray {
                            
                            for each in 0..<array.count {
                                
                                if let description = array[each] as? NSDictionary {
                                    
                                    self.initialDataToshow.append(DataToShow(title: description["title"] as! String, description: description["overview"] as! String, imagePath: description["poster_path"] as! String, dates: description["release_date"] as! String))
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
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
extension NowPlaying: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBegins = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData.removeAll()
        searchBegins = true
        for each in initialDataToshow {
            if (each.title).hasPrefix(searchText) {
                searchData.append(DataToShow(title: each.title, description: each.description, imagePath: each.imagePath, dates: each.dates))
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBegins = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBegins = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBegins = false
    }
    
    
}

extension NowPlaying: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBegins == true {
            return searchData.count
        } else {
            
            return initialDataToshow.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cells", for: indexPath) as! Cells
        
        if searchBegins == false {
            let datas = initialDataToshow[indexPath.row]
            cell.index = indexPath
            cell.delegate = self
            cell.titleLabel.text = datas.title
            cell.decsriptionLabel.text = datas.description
            let url = URL(string: "https://image.tmdb.org/t/p/w342"+datas.imagePath)
            let data = try? Data(contentsOf: url!)
            cell.image.image = UIImage(data: data!)
            cell.image.contentMode = .scaleToFill
            cell.backgroundColor = #colorLiteral(red: 0.9549800754, green: 0.7016262412, blue: 0.2667438984, alpha: 1)
        } else {
            let datas = searchData[indexPath.row]
            cell.index = indexPath
            cell.delegate = self
            cell.titleLabel.text = " "+" "+datas.title
            cell.decsriptionLabel.text = datas.description
            let url = URL(string: "https://image.tmdb.org/t/p/w342"+datas.imagePath)
            let data = try? Data(contentsOf: url!)
            cell.image.image = UIImage(data: data!)
            cell.image.contentMode = .scaleToFill
            cell.backgroundColor = #colorLiteral(red: 0.9549800754, green: 0.7016262412, blue: 0.2667438984, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextPage = DetailsPage(nibName: "DetailsPage", bundle: Bundle.main)
        if searchBegins == false {
            nextPage.dataToShow = [initialDataToshow[indexPath.row]]
        } else {
            nextPage.dataToShow = [searchData[indexPath.row]]
        }
        nextPage.modalPresentationStyle = .fullScreen
        present(nextPage, animated: true, completion: nil)
    }
}
extension NowPlaying: CellDelegate {
    func deleteCell(at row: Int) {
        let index = IndexPath(row: row, section: 0)
        collectionView.performBatchUpdates({
            if searchBegins == false {
                collectionView.deleteItems(at: [index])
                initialDataToshow.remove(at: row)
            } else {
                collectionView.deleteItems(at: [index])
                searchData.remove(at: row)
            }
        }) { (_) in
            self.collectionView.reloadData()
        }
    }
    
    
}
