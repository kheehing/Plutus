//
//  Expense.swift
//  Plutus
//
//  Created by ITP312 on 16/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import Foundation

class Expense: NSObject{
    
    var categories: String
    var desc: String
    var budget: String
    var spent: String
    
    init(_ Categories: String, _ Description: String, _ Budget: String, _ Spent: String) {
        self.categories = Categories
        self.desc = Description
        self.budget = Budget
        self.spent = Spent
    }
}
