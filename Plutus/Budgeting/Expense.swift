//
//  Expense.swift
//  Plutus
//
//  Created by ITP312 on 16/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import Foundation

class Expense: NSObject{
    
    var user: String
    var categories: String
    var desc: String
    var budget: String
    
    init(_ User: String, _ Categories: String, _ Description: String, _ Budget: String) {
        self.user = User
        self.categories = Categories
        self.desc = Description
        self.budget = Budget
    }
}
