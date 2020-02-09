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
    var budgetLeft: Double! = 0.00
    var totalBudget: Double! = 0.00
    var totalSpent: Double! = 0.00
    var db: Firestore!
    var expense: [Expense] = []
    var chartData: [ChartData] = []
    
    var currentSpent: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
//        animatedProgress(progressBar, progress: 0.85, 85)
        tableView.rowHeight = tableView.frame.height / 3.45
//        loadData()
//        checkAmtLabel()
        
        print(Auth.auth().currentUser!.uid)
    }
    
    func loadData() {
        let transaction = db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("transaction").whereField("type", in: ["Bills", "Entertainment", "Food", "Transportation", "Others"])
        
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("budget").getDocuments() { (QuerySnapshot, err)  in
            if let err = err {
                print("error getting docs \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    self.expense.append(Expense(document["categories"] as! String, document["description"] as! String, document["budget"] as! String, document["spent"] as! String))
                }
                transaction.getDocuments() { (snapshot, err2) in
                    if let err2 = err2 {
                        print("error retrieving transaction data budget: \(err2)")
                    } else {
                        for data in snapshot!.documents {
                            self.chartData.append(ChartData((data["time"] as AnyObject).dateValue(), data["amount"] as! String , data["transferee"] as! String, data["transferer"] as! String, data["type"] as! String))
                        }
                    }
                    self.checkSpent()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        createBudget()
        if expense.count > 0 {
            expense.removeAll()
        }
        loadData()
        self.tableView.reloadData()
    }
    
    func checkAmtLabel() {
        totalBudget = 0
        totalSpent = 0
        
        for i in expense {
            totalBudget += Double(i.budget)!
            totalSpent += Double(i.spent)!
        }
        
        if (totalBudget! - totalSpent!) < 0 {
            budgetOver = true
        } else {
            budgetOver = false
        }
        
        budgetAmt.text = "$\(totalBudget!)"
        spentAmt.text = "$\(totalSpent!)"
        
        if (totalSpent != 0) {
            if (totalSpent > totalBudget) {
                if (totalBudget > 0) {
                    animatedProgress(progressBar, progress: 1, percentage: Int((totalSpent!/totalBudget!)*100))
                } else {
                    animatedProgress(progressBar, progress: 1, percentage: Int(totalSpent!*10))
                }
            } else {
                animatedProgress(progressBar, progress: (Float(totalSpent!/totalBudget!)), percentage: Int((totalSpent!/totalBudget!)*100))
            }
        } else {
            animatedProgress(progressBar, progress: 0, percentage: 0)
        }
        
        if budgetOver == false {
            self.spendAmtLabel.attributedText = "You can spend <b>$\(((totalBudget! - totalSpent!)*100).rounded()/100)</b> for the rest of the month!".htmlAttributed(family: "Helvetica", size: 13)
        } else {
            self.spendAmtLabel.text = "You have exceeded your budget!"
            budgetOver = true
        }
    }
    
    func checkSpent() {
        
        for i in 0..<chartData.count {
            
           let changedAmount = Double(chartData[i].amount.prefix(chartData[i].amount.count - 4))
            db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("budget").document(chartData[i].type).updateData([
            "spent": "\(String(format: "%.2f", changedAmount!))"])
        }
        
        self.checkAmtLabel()
    }
    
    private func animatedProgress(_ progressView: CustomProgressView, progress: Float, percentage: Int) {
        UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut, animations: {
            progressView.setProgress(section: 0, to: progress)
        }, completion: nil)
        
        progressView.percentage = percentage
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
