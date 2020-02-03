import UIKit
import FirebaseFirestore
import Firebase

class ViewExpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var expenditures: UIView!
    @IBOutlet weak var tableView: UITableView!
    var db: Firestore!
    var expense: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.rowHeight = tableView.frame.height / 10.5
    }
    
    func loadData() {
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("budget").getDocuments() { (QuerySnapshot, err)  in
            if let err = err {
                print("error getting docs \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    self.expense.append(Expense(document["categories"] as! String, document["description"] as! String, document["budget"] as! String, document["spent"] as! String))
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        expense.removeAll()
        loadData()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath)
        let label = UILabel.init(frame: CGRect(x:0, y:0, width: 135, height: 20))
        
        cell.textLabel?.text = expense[indexPath.row].categories
        cell.detailTextLabel?.text = expense[indexPath.row].desc
        label.text = "$\(expense[indexPath.row].spent)  |  $\(expense[indexPath.row].budget)"
        label.textAlignment = .right
        cell.accessoryView = label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        return expense.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editBudget") {
            let editExpVC = segue.destination as! AddExpViewController
            let selectedRow = self.tableView.indexPathForSelectedRow
            
            if (selectedRow != nil) {
                let selectedBudget = expense[selectedRow!.row]
                editExpVC.expense = selectedBudget
            }
        }
    }
}
