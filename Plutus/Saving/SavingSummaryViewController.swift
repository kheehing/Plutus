//
//  SavingSummaryViewController.swift
//  Plutus
//
//  Created by ITP312 on 6/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class SavingSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var db: Firestore!
    var savingHist: [SavingHistory] = []
    var totalSavings = 0
    var savingOften = 0
    var savingAmt = 0
    var savingDate = Date()
    let currentUserID:String = Auth.auth().currentUser!.uid
    var ttsv = [String : Any]()
    
    @IBOutlet weak var savingStatement: UILabel!
    @IBOutlet weak var totalSavingValue: UILabel!
    
    @IBOutlet weak var savingHistoryTableView: UITableView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    
    @IBOutlet weak var currentSavingValue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        savingHistoryTableView.rowHeight = savingHistoryTableView.frame.height / 3.45
        self.viewMoreBtn.isHidden = true
        db = Firestore.firestore()
        
        

        
        let group = DispatchGroup()
        group.enter()
self.navigationController?.isNavigationBarHidden = false
        db.collection("savings").whereField("name", isEqualTo: "Afiq").order(by: "date", descending: true)
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
                        self.totalSavings = self.totalSavings + amt
                    }
                }
        }
        
        db.collection("savings").whereField("name", isEqualTo: "Afiq").order(by: "date", descending: true).limit(to: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.savingOften = document["savingOften"] as! Int
                        self.savingAmt = document["amount"] as! Int
                        if let timestamp = document["date"] as? Timestamp { self.savingDate = timestamp.dateValue()}
                        group.leave()
                    }
                }
        }
        
        
        
        db.collection("users").document("\(self.currentUserID)").collection("balanceSaving")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching documents3: \(error!)")
                    return
                }
               
                self.ttsv = document.data()!
        }

        
        initSavingStatement(0, 0)
        
        // Only executed when group.enter() and group.leave() are balanced
        group.notify(queue: .main) {
            self.checkDeductionTime()
        }
    }
    
    
    // Ideally should work when the user visted this saving page(?)
    // Edit: No idea where to place this function, looping million of times at the usual spot
    func checkDeductionTime() {
        let currentDate = Date()
        let latestDate = savingDate
        
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: currentDate)
        let date2 = calendar.startOfDay(for: latestDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        // Need to check for savingOften then compare with 1, 7, or 30 but for testing purpose it should create everytime when visited(?)
        // Edit: It keeps creating and creating and creating when < 1 !!!
        let oft = self.savingOften
        var dateNum = 1
        switch oft {
        case 0:
            dateNum = 1
            
        case 1:
            dateNum = 7
            
        case 2:
            dateNum = 30
            
        default:
            return
        }
        
        print("Date Num is:", dateNum)
        print("Days Difference is:", components.day!)
        if components.day! > dateNum { // This will return the number of day(s) between dates
            let ref = db.collection("savings").addDocument(data: [
                "name": "Afiq",
                "amount": self.savingAmt,
                "savingOften": self.savingOften,
                "date": NSDate()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
            }
            
            self.savingHistoryTableView.reloadData()
            self.totalSavingValue.text = "$\(self.totalSavings + self.savingAmt)"
        }
    }
    
    func initSavingStatement(_ often: Int, _ amt: Int) {
        var date = ""
        switch often {
        case 0:
            date = "day"
            
        case 1:
            date = "week"
            
        case 2:
            date = "month"
            
        default:
            return
        }
        self.savingStatement.text = "You are saving $\(amt) every \(date)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            self.savingHistoryTableView.reloadData()
            if self.savingHist.count > 3 {
                self.viewMoreBtn.isHidden = false
            }
            self.totalSavingValue.text = "$\(self.totalSavings)"
            if self.ttsv["sgd"] != nil {
                self.currentSavingValue.text = "$\(self.ttsv["sgd"]!)"
            }
            else {
                self.currentSavingValue.text = "$\(self.ttsv["sgd"])"
            }
            self.initSavingStatement(self.savingOften, self.savingAmt)
        }
        if savingHist.count > 3 {
            return 3
        }
        else {
            return savingHist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savingHistoryCell", for: indexPath)
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        let dateResult = dateFormatter.string(from: savingHist[indexPath.row].date)
        
        cell.textLabel?.text = dateResult
        cell.detailTextLabel?.text = "$"+String(savingHist[indexPath.row].amount)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            
            navigationItem.backBarButtonItem = backItem
        
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        let s = UIStoryboard(name: "Saving", bundle: nil)
        let v = s.instantiateViewController(withIdentifier:"SavingPickerVC")
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func takeOutSaving(_ sender: Any) {
        var data = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        var data2 = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        var data3 = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        db.collection("users").document("\(currentUserID)").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document1: \(error!)")
                return
            }
            data = document.data()!
        }
        db.collection("users").document("\(self.currentUserID)").collection("balanceWallet")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document2: \(error!)")
                    return
                }
                data2 = document.data()!
        }
        db.collection("users").document("\(self.currentUserID)").collection("balanceSaving")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching documents3: \(error!)")
                    return
                }
                data3 = document.data()!
        }
        
        func dataValueOnChange(){
            if (!data.isEmpty && !data2.isEmpty && !data3.isEmpty){

                guard let walletAmount1:Int = data2["sgd"] as? Int else {
                    print("Error feteching amount1")
                    return
                }

                guard let savingAmount1:Int = data3["sgd"] as? Int else {
                    print("Error feteching amount2")
                    return
                }
                
//                guard let walletAmount2:Int = data2["usd"] as? Int else {
//                    print("Error feteching amount1")
//                    return
//                }
//
//                guard let savingAmount2:Int = data3["usd"] as? Int else {
//                    print("Error feteching amount2")
//                    return
//                }
                
            db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else { self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "sgd" :  walletAmount1 + savingAmount1 ])
                        
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceSaving").document("currency").updateData([ "sgd" :  savingAmount1 - savingAmount1 ])
                        
                        
//                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "usd" :  walletAmount2 + savingAmount2 ])
//
//                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceSaving").document("currency").updateData([ "usd" :  savingAmount2 - savingAmount2 ])
                        
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    

    @IBAction func depositSaving(_ sender: Any) {
        var data = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        var data2 = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        var data3 = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        db.collection("users").document("\(currentUserID)").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document1: \(error!)")
                return
            }
            data = document.data()!
        }
        db.collection("users").document("\(self.currentUserID)").collection("balanceWallet")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document2: \(error!)")
                    return
                }
                data2 = document.data()!
        }
        db.collection("users").document("\(self.currentUserID)").collection("balanceSaving")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching documents3: \(error!)")
                    return
                }
                data3 = document.data()!
        }
        
        func dataValueOnChange(){
            if (!data.isEmpty && !data2.isEmpty && !data3.isEmpty){
                
                guard let walletAmount1:Int = data2["sgd"] as? Int else {
                    print("Error feteching amount1")
                    return
                }
                
                guard let savingAmount1:Int = data3["sgd"] as? Int else {
                    print("Error feteching amount2")
                    return
                }
                
//                guard let walletAmount2:Int = data2["usd"] as? Int else {
//                    print("Error feteching amount1")
//                    return
//                }
//
//                guard let savingAmount2:Int = data3["usd"] as? Int else {
//                    print("Error feteching amount2")
//                    return
//                }
                
                db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "sgd" :  walletAmount1 - self.savingAmt])
                        
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceSaving").document("currency").updateData([ "sgd" :  savingAmount1 + self.savingAmt ])
                        
//                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "usd" :  walletAmount2 - self.savingAmt ])
//
//                        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceSaving").document("currency").updateData([ "usd" :  savingAmount2 + self.savingAmt ])
                        
//                            self.db.collection("savings").addDocument(data: [
//                                "name": "Afiq",
//                                "amount": self.savingAmt,
//                                "savingOften": self.savingOften,
//                                "date": NSDate()
//                            ]) { err in
//                                if let err = err {
//                                    print("Error adding document: \(err)")
//                                } else {
//                                    print("Document added")
//                                }
//                            }
                        
                        
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                        
                    }
                }
            }
        }
    }
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
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
