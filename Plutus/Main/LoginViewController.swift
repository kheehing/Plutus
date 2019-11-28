//
//  LoginViewController.swift
//  Plutus
//
//  Created by ITP312 on 28/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var plutusTitle: UILabel!
    @IBOutlet weak var PhoneTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        plutusTitle.text = "Plutus"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.PhoneTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    @IBAction func NextOnClick(_ sender: Any) {
    }
    
}
