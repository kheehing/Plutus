//
//  PeopleViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 3/2/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPeopleButton: UIBarButtonItem!
    
    var receiptID : String = ""
    var transactions : [String] = []
    var whoIs : [String] = []
    var db : Firestore!
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell.
        let cell : PersonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonTableViewCell
        cell.userLabel.text = "hello" //self.whoIs[indexPath.section]
        cell.totalLabel.text = "hi" //self.transactions[indexPath.section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return whoIs.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectPersonSegue"){
            let vc = segue.destination as! ContactsViewController
                vc.receiptID = receiptID
            }
        }
}

