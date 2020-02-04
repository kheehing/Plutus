//
//  SavingHistoryViewController.swift
//  Plutus
//
//  Created by Justin Tey on 4/2/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class SavingHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: Firestore!
    var savingHist: [SavingHistory] = []
    
    @IBOutlet weak var fullSavingHistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        db = Firestore.firestore()
        let data = db.collection("savings").whereField("name", isEqualTo: "Afiq").order(by: "date", descending: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        var date = Date()
                        if let timestamp = document["date"] as? Timestamp { date = timestamp.dateValue()}
                        let amt = document["amount"] as! Int
                        self.savingHist.append(SavingHistory(date, amt))
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            self.fullSavingHistTableView.reloadData()
        }
        return savingHist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullSavingHistCell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        let dateResult = dateFormatter.string(from: savingHist[indexPath.row].date)
        
        cell.textLabel?.text = dateResult
        cell.detailTextLabel?.text = "$"+String(savingHist[indexPath.row].amount)
        return cell
    }

}
