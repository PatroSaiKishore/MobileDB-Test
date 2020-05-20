//
//  DetailsPage.swift
//  Test-MovieApp
//
//  Created by saikishore on 19/05/20.
//  Copyright © 2020 saikishore. All rights reserved.
//

import UIKit

class DetailsPage: UIViewController {

    var dataToShow = [DataToShow]()
    @IBOutlet var backGroundImage: UIImageView!
    @IBOutlet var titleName: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataToShowWithData()
    }
    func dataToShowWithData() {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w342"+dataToShow[0].imagePath)
        let data = try? Data(contentsOf: url!)
        backGroundImage.image = UIImage(data: data!)
        titleName.text = dataToShow[0].title
        descriptionText.text = dataToShow[0].description
        date.text = dataToShow.first?.dates
    }
    
    @IBAction func onTappingback(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
