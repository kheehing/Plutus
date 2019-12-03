//
//  Terms&ConditionsViewController.swift
//  Plutus
//
//  Created by ITP312 on 3/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import Hero

class Terms_ConditionsViewController: UIViewController {
    @IBOutlet weak var PlutusPrivacyPolicy: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        PlutusPrivacyPolicy.hero.id = "PlutusPrivacyPolicy"
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
