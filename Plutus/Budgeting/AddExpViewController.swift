import UIKit
import Firebase
import FirebaseFirestore

class AddExpViewController: UIViewController{

    @IBOutlet weak var addExp: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var budgetField: UITextField!
    
    var db: Firestore!
    var expense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        categoryField.text = expense?.categories
        descField.text = expense?.desc
        budgetField.text = expense?.budget
        
//        createCatPicker()
        budgetField.keyboardType = .numberPad
        addBtn.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("budget").document(categoryField.text!).updateData([
            "description": descField.text!,
            "budget": budgetField.text!
            ])
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
