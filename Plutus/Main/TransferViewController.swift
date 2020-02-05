import UIKit
import FirebaseFirestore
import Firebase

class TransferViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var displayBalance: UILabel!
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
    var currencySelected = "sgd"
    var data2 = [String : Any](){
        didSet{
            DispatchQueue.main.async {
                let this:Double = self.data2[String(describing: self.currencyButton.currentTitle!.lowercased())] as! Double
                self.displayBalance.text = "You have: \(round(1000*this)/1000) \(self.currencyButton.currentTitle!.uppercased())"
                print(self.data2[String(describing: self.currencyButton.currentTitle!.lowercased())]!)
            }
        }
    };
    let pickerData = [
        "SGD",
        "USD",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Transfer"
        db = Firestore.firestore()
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document2: \(error!)")
                    return
                }
                self.data2 = document.data()!
        }
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
        displayBalance.text = "You have: \(data2[String(describing:self.currencyButton.currentTitle!.lowercased())]!) \(self.currencyButton.currentTitle!.uppercased())"
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
        } else if (Int(amount)! <= 0){
            alert(title: "Error", message: "Transfering amount cannot be negative or zero.")
        } else {
            db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let sData = snapshot!.data()!
                    let amountType = self.currencyButton.currentTitle!.lowercased()
                    let amountBank = sData["\(amountType)"]!
                    let amountEntered:Int = Int(amount)!
                    if (Int("\(amountBank)")! < Int(amountEntered)) {
                        self.alert(title: "Invalid number", message: "You bank doesn't have $\(amountEntered) \(amountType.uppercased()), \nit only has $\(amountBank) \(amountType.uppercased()).")
                    } else if ("+65\(mobileNumber)" == Auth.auth().currentUser!.phoneNumber!){
                        print("moneyself")
                        self.alert(title: "Error", message: "you can not transfer money to yourself.")
                    } else {
                        self.db.collection("users").whereField("mobileNumber", isEqualTo: "+65\(mobileNumber)").getDocuments(){ (Tsnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                if (Tsnapshot!.isEmpty){
                                    self.alert(title: "Invalid number", message: "the mobile number does not exist in out database, please check if you have entered the correct number.")
                                } else {
                                    for document in Tsnapshot!.documents {
                                        self.db.collection("users").document(document.documentID).collection("balanceWallet").document("currency").getDocument{ (snapshott,err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                            } else {
                                                
                                            self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "sgd" : snapshot!.data()![amountType] as! Int - amountEntered ]) // transferer
                                                self.db.collection("users").document(document.documentID).collection("balanceWallet").document("currency").updateData([ "sgd" : snapshott!.data()![amountType] as! Int + amountEntered ]) // transferee
                                                
                                                self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("transaction").addDocument(data: [
                                                    "type": "transfer",
                                                    "transferer": Auth.auth().currentUser!.displayName!,
                                                    "transferee": "\(document.data()["firstName"]!) \(document.data()["lastName"]!)",
                                                    "time": Timestamp(date: Date()),
                                                    "amount": "\(amountEntered) \(amountType.uppercased())",]) // transferer
                                                self.db.collection("users").document(document.documentID).collection("transaction").addDocument(data: [
                                                    "type": "transfer",
                                                    "transferer": Auth.auth().currentUser!.displayName!,
                                                    "transferee": "\(document.data()["firstName"]!) \(document.data()["lastName"]!)",
                                                    "time": Timestamp(date: Date()),
                                                    "amount": "\(amountEntered) \(amountType.uppercased())",]) // transferer
                                                if let navController = self.navigationController {
                                                    navController.popViewController(animated: true)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        print("bank: \(amountBank)")
                        print("entered: \(amountEntered )")
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
}
