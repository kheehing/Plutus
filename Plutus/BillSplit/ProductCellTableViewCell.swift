//
//  ProductCellTableViewCell.swift
//  Plutus(Local)
//
//  Created by ITP312 on 23/1/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class ProductCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBOutlet weak var ProductLabel: UILabel!
}
