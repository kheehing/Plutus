//
//  testViewController.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 9/2/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class testViewController: UIViewController {

    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("transaction").document("BSXNgnoQvHLGRv1wUDOH").getDocument{
            (document,error) in
            if let error = error {
                print("Error retrieving code: \(error)")
            }
            if let document = document {
                let x:Date = (document["time"]! as AnyObject).dateValue()
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd/MM"
                
                if let date = dateFormatterGet.date(from: "\(x)") {
                    print(dateFormatterPrint.string(from: date))
                } else {
                    print("There was an error decoding the string")
                }
                print(x)
            }
        }
        // Do any additional setup after loading the view.
    }
}
