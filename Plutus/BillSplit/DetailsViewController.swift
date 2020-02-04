//
//  DetailsViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 3/2/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var ProductLabel: UILabel!
    
    var pricing : String?
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        ProductLabel.text = pricing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
