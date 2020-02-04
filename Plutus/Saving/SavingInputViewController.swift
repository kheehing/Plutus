//
//  SavingInputViewController.swift
//  Plutus
//
//  Created by ITP312 on 6/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class SavingInputViewController: UIViewController {

    var pickedDate : Int?
    
    @IBOutlet weak var textViewText: UITextView!
    
    @IBOutlet weak var inputAmount: UITextField!
    
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if pickedDate != nil {
            switch pickedDate {
                
            case 0:
                textViewText.text = "How much would you like to save per day?"
                
            case 1:
                textViewText.text = "How much would you like to save per week?"
                
            case 2:
                textViewText.text = "How much would you like to save per month?"
                
            default:
                return
            }
        }
        db = Firestore.firestore()
    }
    
    @IBAction func moveToNextPage(_ sender: Any) {
        if inputAmount.text != nil {
            self.performSegue(withIdentifier: "movetoconfirmpage", sender: self)
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SavingConfirmViewController {
            let vc = segue.destination as? SavingConfirmViewController
            let ref = db.collection("savings").addDocument(data: [
                "name": "Afiq",
                "amount": Int(inputAmount.text!),
                "savingOften": pickedDate!,
                "date": NSDate()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
            }
        }
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
