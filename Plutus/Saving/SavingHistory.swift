//
//  SavingHistory.swift
//  Plutus
//
//  Created by Justin Tey on 3/2/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class SavingHistory {
    var date: Date
    var amount: Int = 0
    
    init(_ date: Date, _ amount: Int) {
        self.date = date
        self.amount = amount
    }
}
