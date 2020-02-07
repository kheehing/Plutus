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
    var total : Double = 0.00
    var details : [String] = []
    var transactions : [String] = []
    var whoIs : [String] = []


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView?.allowsMultipleSelection = true
        
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
    
    @IBAction func selectButtonAction(_ sender: Any) {
        let selectedItems = tableView?.indexPathsForSelectedRows
        var stuffD : Double
        for indexPath in selectedItems! {
            stuffD = Double(PitemList[indexPath.section]) as! Double
            total = stuffD + total
            self.details.append(Person)
            self.details.append(String(total))
            print("Item is $\(stuffD). Total is \(total).")
        }
        sendTransactionText()
        retrievePeople()
        performSegue(withIdentifier: "AddedPeopleSegue", sender: self)
    }
    
    private func sendTransactionText() {
        self.db.collection("receipt").document(receiptID).collection("transactions").addDocument(data: [
            "User" : Person!,
            "Total" : String(total)]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
        }
    }
    
    private func retrievePeople() {
        self.db.collection("receipt").document(receiptID).collection("transactions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let pie = document.data()
                    print("\(document.documentID) => \(document.data()), \(pie["User"]!)")
                    self.transactions.append(pie["Total"]! as! String)
                    self.whoIs.append(pie["User"]! as! String)
                    print(self.transactions)
                    print(self.whoIs)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddedPeopleSegue"){
            let vc = segue.destination as! PeopleViewController
            vc.receiptID = receiptID
            vc.transactions = transactions
            vc.whoIs = whoIs
        }
    }
}
