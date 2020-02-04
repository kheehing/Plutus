//
//  PeopleViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 3/2/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var addPeopleButton: UIBarButtonItem!
    var receiptID : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectPersonSegue"){
            let vc = segue.destination as! ContactsViewController
                vc.receiptID = receiptID
            }
        }
}
