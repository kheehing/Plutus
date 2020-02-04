//
//  SavingInfoViewController.swift
//  Plutus
//
//  Created by ITP312 on 6/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class SavingInfoViewController: UIViewController {
    var db: Firestore!
    
    @IBOutlet weak var coinImg: UIImageView!
    @IBOutlet weak var textOne: UITextView!
    @IBOutlet weak var textTwo: UITextView!
    @IBOutlet weak var nextbtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinImg.isHidden = true
        textOne.isHidden = true
        textTwo.isHidden = true
        nextbtn.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        db = Firestore.firestore()
        let data = db.collection("savings").whereField("name", isEqualTo: "Afiq").getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot?.count != 0 {
                    let s = UIStoryboard(name: "Saving", bundle: nil)
                    let v = s.instantiateViewController(withIdentifier:"SavingSummaryVC")
                    self.navigationController?.pushViewController(v, animated: false)
                }
                else
                {
                    self.coinImg.isHidden = false
                    self.textOne.isHidden = false
                    self.textTwo.isHidden = false
                    self.nextbtn.isEnabled = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func unwindToHomePage(segue:UIStoryboardSegue) { }

}
