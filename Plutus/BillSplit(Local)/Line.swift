//
//  Line.swift
//  Plutus(Local)
//
//  Created by ITP312 on 28/1/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Line: NSObject {
    var lineNo: String
    var actualLine: String
    
    init(lineNo: String, actualLine: String){
        self.lineNo = lineNo
        self.actualLine = actualLine
    }
}
