//
//  ContactsViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 4/2/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var receiptID : String = ""
    var contacts : [String] = ["Bob","Steve"]
    var itemList : [String] = []
    var db : Firestore!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        retrieveReceipt()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell.
        let cell : ContactsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsTableViewCell
        cell.ContactsLabel.text = contacts[indexPath.section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.count
    }
    
    private func retrieveReceipt() {
        let docRef = db.collection("receipt").document(receiptID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.itemList = document.get("numbers") as! [String]
                print("This is supposed to be \(self.itemList)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectAmountSegue"){
            let vc = segue.destination as! SelectPayViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if(myIndexPath != nil){
                let contact = contacts[(myIndexPath?.section)!]
                vc.Person = contact
                vc.receiptID = receiptID
                vc.PitemList = itemList
            }
        }
    }
}
