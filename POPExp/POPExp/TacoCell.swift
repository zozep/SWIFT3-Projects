//
//  TacoCell.swift
//  POPExp
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class TacoCell: UICollectionViewCell, NibLoadableView {
    
    @IBOutlet weak var tacoImage: UIImageView!
    @IBOutlet weak var tacoLabel: UILabel!
    
    var taco: Taco!
    
    func configureCell(taco: Taco) {
        self.taco = taco
        tacoImage.image = UIImage(named: taco.proteinID.rawValue)
        tacoLabel.text = taco.productName
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

}
