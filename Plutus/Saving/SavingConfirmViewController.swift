//
//  SavingConfirmViewController.swift
//  Plutus
//
//  Created by ITP312 on 6/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit

class SavingConfirmViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SavingSummaryViewController {
            let vc = segue.destination as? SavingSummaryViewController
        }
    }
    
}
