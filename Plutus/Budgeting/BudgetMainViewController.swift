//
//  BudgetMainViewController.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 28/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import MultiProgressView
import FirebaseFirestore

class BudgetMainViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource, MultiProgressViewDataSource {

    @IBOutlet weak var cardTest: UIView!
    @IBOutlet weak var cashFlow: UIView!
    @IBOutlet weak var expenditure: UIView!
    
    
    //spent and budget labels
    @IBOutlet weak var spentAmt: UILabel!
    @IBOutlet weak var budgetAmt: UILabel!
    @IBOutlet weak var spendAmtLabel: UILabel!
    
    //cash flow labels
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var ytdLabel: UILabel!
    @IBOutlet weak var tdyLabel: UILabel!
    
    //expenditure
    @IBOutlet weak var tableView: UITableView!
    
    //progress bar
    @IBOutlet weak var progressBar: CustomProgressView!
    
    var budgetOver = false
    var budgetLeft = 15
    var db: Firestore!
    var expense: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        checkAmtLabel()
        animatedProgress(progressBar, progress: 0.85)
        
        tableView.rowHeight = tableView.frame.height / 3.45
    }
    
    func loadData() {
        db.collection("expenditure").getDocuments() { (QuerySnapshot, err)  in
            if let err = err {
                print("error getting docs \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    self.expense.append(Expense(document["user"] as! String, document["categories"] as! String, document["description"] as! String, document["budget"] as! String))
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(expense.count >= 0) {
            expense.removeAll()
            loadData()
        }
        self.tableView.reloadData()
    }
    
    func checkAmtLabel() {
        if budgetOver == false {
            self.spendAmtLabel.attributedText = "You can spend <b>$\(budgetLeft)</b> for the rest of the month!".htmlAttributed(family: "Helvetica", size: 13)
        } else {
            self.spendAmtLabel.text = "You have exceeded your budget!"
            budgetOver = true
        }
    }
    
    private func animatedProgress(_ progressView: CustomProgressView, progress: Float) {
        UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut, animations: {
            progressView.setProgress(section: 0, to: progress)
        }, completion: nil)
        
        progressView.percentage = 85
    }
    
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 1
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let budgetLeft = ProgressViewSection()
        budgetLeft.backgroundColor = UIColor.init(red: 160/255, green: 51/255, blue: 52/255, alpha: 1)
        
        return budgetLeft
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        return expense.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        let label = UILabel.init(frame: CGRect(x:0, y:0, width: 100, height: 20))
        
        if indexPath.row <= 3 {
            cell.textLabel?.text = expense[indexPath.row].categories
            cell.detailTextLabel?.text = expense[indexPath.row].desc
            label.text = expense[indexPath.row].budget
            cell.accessoryView = label
        }
        return cell
    }
    
}
