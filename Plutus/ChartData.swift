//
//  ChartData.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 10/2/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import Foundation

class ChartData: NSObject {

    var date: Date
    var amount: String
    var xferee: String
    var xferer: String
    var type: String
    
    init(_ Date: Date, _ Amount: String, _ Xferee: String = "", _ Xferer: String = "", _ Type: String) {
        self.date = Date
        self.amount = Amount
        self.xferee = Xferee
        self.xferer = Xferer
        self.type = Type
    }
}
