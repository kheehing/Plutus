//
//  CollectionViewCell.swift
//  Plutus
//
//  Created by ITP312 on 10/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var testLabel: UILabel!
    @IBOutlet var cntView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            self.cntView.layer.shadowColor = UIColor.gray.cgColor
            self.cntView.layer.shadowOpacity = 0.5
            self.cntView.layer.shadowOffset = .zero
            self.cntView.layer.shadowOpacity = 10.0
            self.cntView.layer.shadowPath = UIBezierPath(rect: self.cntView.bounds).cgPath
            self.cntView.layer.shouldRasterize = true
        }
    }

}
