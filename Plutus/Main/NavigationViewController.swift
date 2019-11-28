//
//  NavigationViewController.swift
//  Plutus
//
//  Created by ITP312 on 28/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "#4a5866")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    

}
