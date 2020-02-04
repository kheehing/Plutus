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
//    let categories = ["Bills", "Transportation", "Food", "Entertainment", "Others"]
//    var selectedCat: String?
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
//    func createCatPicker() {
//        let catPicker = UIPickerView()
//        catPicker.delegate = self
//        categoryField.inputView = catPicker
//
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
//
//        toolbar.setItems([space, space, doneBtn], animated: false)
//        toolbar.isUserInteractionEnabled = true
//
//        categoryField.inputAccessoryView = toolbar
//    }
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return categories.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return categories[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedCat = categories[row]
//        categoryField.text = selectedCat
//    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("budget").document(categoryField.text!).updateData([
            "description": descField.text!,
            "budget": budgetField.text!
            ])
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
