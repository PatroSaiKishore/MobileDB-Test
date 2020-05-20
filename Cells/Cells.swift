//
//  Cells.swift
//  Test-MovieApp
//
//  Created by saikishore on 18/05/20.
//  Copyright © 2020 saikishore. All rights reserved.
//

import UIKit

class Cells: UICollectionViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var decsriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    var delegate: CellDelegate!
    var index: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onToClickToDelete(sendr: UIButton) {
        delegate.deleteCell(at: index.row)
    }
}

protocol CellDelegate {
    func deleteCell(at row: Int)
}
