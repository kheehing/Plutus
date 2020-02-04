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
    var PitemList : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(animated)
        retrieveReceipt()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView?.allowsMultipleSelection = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell.
        let cell : ItemCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemCellTableViewCell
        cell.itemLabel.text = PitemList[indexPath.section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PitemList.count
    }
    
    
    
    private func retrieveReceipt() {
        let docRef = db.collection("receipt").document(receiptID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.PitemList = document.get("text") as! [String]
                print("This is supposed to be \(self.PitemList)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
