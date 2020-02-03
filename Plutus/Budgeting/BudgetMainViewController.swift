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
import Firebase

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
    var exampleBudget: Double! = 0.00
    var currentSpent: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        animatedProgress(progressBar, progress: 0.85)
        tableView.rowHeight = tableView.frame.height / 3.45
        createBudget()
//        loadData()
//        checkAmtLabel()
        
        print(Auth.auth().currentUser!.uid)
    }
    
    func loadData() {
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("budget").getDocuments() { (QuerySnapshot, err)  in
            if let err = err {
                print("error getting docs \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    self.expense.append(Expense(document["categories"] as! String, document["description"] as! String, document["budget"] as! String, document["spent"] as! String))
                }
            }
            self.checkAmtLabel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        expense.removeAll()
        loadData()
        self.tableView.reloadData()
    }
    
    func checkAmtLabel() {
        exampleBudget = 0
        for i in expense {
            exampleBudget += Double(i.budget)!
        }
        
        if budgetOver == false {
            self.spendAmtLabel.attributedText = "You can spend <b>$\(exampleBudget!)</b> for the rest of the month!".htmlAttributed(family: "Helvetica", size: 13)
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
        
        return expense.count - 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        let label = UILabel.init(frame: CGRect(x:5, y:0, width: 135, height: 20))
        let budget = Float(expense[indexPath.row].budget)
        
        if indexPath.row <= 3 {
            cell.textLabel?.text = expense[indexPath.row].categories
            cell.detailTextLabel?.text = expense[indexPath.row].desc
            label.text = "$\(expense[indexPath.row].spent)  |  $\(expense[indexPath.row].budget)"
            label.textAlignment = .right
            if (budget! - budget!) != 0.0 {
                label.textColor = .red
            }
            cell.accessoryView = label
        }
        return cell
    }
    
    func createBudget() {
        let budgetLink = db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("budget")
        budgetLink.getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("error \(err)")
            } else {
                if QuerySnapshot!.documents.isEmpty {
                    budgetLink.document("Bills").setData(["description": "None",
                                                          "budget": "0",
                                                          "spent": "0",
                                                          "categories": "Bills"])
                    budgetLink.document("Entertainment").setData(["description": "None",
                                                                  "budget": "0",
                                                                  "spent": "0",
                                                                  "categories": "Entertainment"])
                    budgetLink.document("Food").setData(["description": "None",
                                                         "budget": "0",
                                                         "spent": "0",
                                                         "categories": "Food"])
                    budgetLink.document("Transportation").setData(["description": "None",
                                                                   "budget": "0",
                                                                   "spent": "0",
                                                                   "categories": "Transportation"])
                    budgetLink.document("Others").setData(["description": "None",
                                                           "budget": "0",
                                                           "spent": "0",
                                                           "categories": "Others"])
                }
            }
        }
    }
}
