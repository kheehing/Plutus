import UIKit
import FirebaseFirestore
import Firebase

class TransferViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var currencyButton: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPickerView = pickerData[row]
        currencyButton.setTitle("\(selectedPickerView.uppercased())", for: .normal)
    }
    
    var db: Firestore!
    var toolBar = UIToolbar()
    var picker = UIPickerView()
    let pickerData = [
        "SGD",
        "USD",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Transfer"
        db = Firestore.firestore()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }


    @IBAction func CurrencyOnClick(_ sender: Any) {
        onDoneButtonTapped()
        dismissKeyboard()
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(false)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @IBAction func submitOnClick(_ sender: Any) {
        check()
    }
    
    func check(){
        print("check()")
        let mobileNumber = numberTextField.text!
        let amount = amountTextField.text!
        if (mobileNumber.isEmpty){
            if (amount.isEmpty){
                alert(title: "Empty Fields", message: "make all fields are filled.")
            } else {
                alert(title: "Empty Field", message: "make sure you enter an amount.")
            }
        } else if (amount.isEmpty){
            alert(title: "Empty Field", message: "make sure you enter the transferee's number.")
        } else {
            db.collection("users").whereField("mobileNumber", isEqualTo: "+65\(mobileNumber)").getDocuments(){ (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if (snapshot!.isEmpty){
                        print("empty snapshot")
                        self.alert(title: "Invalid number", message: "the mobile number does not exist in out database, please check if you have entered the correct number.")
                    }
                    for document in snapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
            db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
            if let err = err {
                print("Error getting documents: \(err)")
                } else {
                    let sData = snapshot!.data()
                    let amountType = self.currencyButton.currentTitle!.lowercased()
                    let amountEntered = Int(amount)
                    let amountBank = sData!["\(amountType)"]!
                
                    print(sData as Any)
                    print("bank: \(amountBank)")
                    print("entered: \(amountEntered ?? 0)")
                }
            }
        }
    }
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
