//
//  MessageUI.swift
//  Plutus
//
//  Created by Justin Tey on 21/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

enum MessageType {
    case user
    case botText
}

class MessageUI {

    var text: String = ""
    var type: MessageType
    
    init(type: MessageType) {
        self.type = type
    }
    
    convenience init(text: String, type: MessageType) {
        self.init(type: type)
        self.text = text
    }
    
    
}
