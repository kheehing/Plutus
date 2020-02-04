//
//  SelectPayViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 4/2/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


class SelectPayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    var Person : String!
    var receiptID : String = ""
    var db : Firestore!
    var itemList : [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        retrieveReceipt()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell.
        let cell : ItemCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemCellTableViewCell
        cell.itemLabel.text = itemList[indexPath.section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemList.count
    }
    
    private func retrieveReceipt() {
        let docRef = db.collection("receipt").document(receiptID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.itemList = document.get("text") as! [String]
            } else {
                print("Document does not exist")
            }
        }
    }
}
