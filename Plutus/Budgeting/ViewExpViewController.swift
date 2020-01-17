import UIKit
import FirebaseFirestore

class ViewExpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var expenditures: UIView!
    @IBOutlet weak var tableView: UITableView!
    var db: Firestore!
    var expense: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        tableView.rowHeight = tableView.frame.height / 10.5
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
//        if(expense.count >= 0) {
            expense.removeAll()
            loadData()
//        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath)
        let label = UILabel.init(frame: CGRect(x:0, y:0, width: 100, height: 20))
        
        cell.textLabel?.text = expense[indexPath.row].categories
        cell.detailTextLabel?.text = expense[indexPath.row].desc
        label.text = expense[indexPath.row].budget
        cell.accessoryView = label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        return expense.count
    }
}
