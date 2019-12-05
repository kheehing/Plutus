//
//  OTPViewController.swift
//  Plutus
//
//  Created by ITP312 on 5/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {
    @IBOutlet weak var userNumber: UILabel!
    var number: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNumber?.text = number
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
