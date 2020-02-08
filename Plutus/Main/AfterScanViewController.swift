import UIKit
import Firebase
import FirebaseFirestore

class AfterScanViewController: UIViewController {
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var TransfereeTextField: UITextField!
    
    var db:Firestore!
    var amount:Int = 0
    var currency:String = ""
    var type:String = ""
    var transferee:String = ""
    var transfereeUID:String = ""
    var transfererBalance:Int = 0
    var transfereeBalance: Int = 0
    let transferer:String = Auth.auth().currentUser!.displayName!
    let transfererUID:String = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.title =  "Confirm Payment"
        amountTextField.isEnabled = false
        categoryTextField.isEnabled = false
        TransfereeTextField.isEnabled = false
        amountTextField.text = "\(amount) \(currency.uppercased())"
        categoryTextField.text = "\(type)"
        TransfereeTextField.text = "\(transferee)"
        self.navigationController!.isNavigationBarHidden = false
        print(amount,"\n",currency,"\n",type,"\n",transferee,"\n",transfererUID,"\n",transferer)
        db.collection("users").document(transfereeUID).collection("balanceWallet").document("currency").getDocument{
            (snapshot, error) in
            if let error = error {
                print("Error \(error)")
            }
            if let document = snapshot {
                self.transfereeBalance = document.data()![self.currency.lowercased()]! as! Int
            }
        }
        db.collection("users").document(transfererUID).collection("balanceWallet").document("currency").getDocument{
            (snapshot,error) in
            if let error = error {
                print("Error \(error)")
            }
            if let document = snapshot {
                self.transfererBalance = document.data()![self.currency.lowercased()]! as! Int
            }
        }
    }
    
    @IBAction func sendOnClick(_ sender: Any) {
        check()
    }
    
    func check(){
        if (transfererBalance < amount){
            alert(title: "Error", message: "You do not have sufficient amount of money in your account")
        } else {
            self.db.collection("users").document(transfererUID).collection("balanceWallet").document("currency").updateData([ "\(currency.lowercased())" : transfererBalance - amount ]) // transferer
            self.db.collection("users").document(transfereeUID).collection("balanceWallet").document("currency").updateData([ "\(currency.lowercased())" : transfereeBalance + amount ]) // transferee
            if (transferer == transferee){
                self.db.collection("users").document(transfererUID).collection("transaction").addDocument(data: [
                    "type": type,
                    "transferer": transferer,
                    "transferee": transferee,
                    "time": Timestamp(date: Date()),
                    "amount": "\(amount) \(currency.uppercased())",]) // transferer
            } else {
                self.db.collection("users").document(transfererUID).collection("transaction").addDocument(data: [
                    "type": type,
                    "transferer": transferer,
                    "transferee": transferee,
                    "time": Timestamp(date: Date()),
                    "amount": "\(amount) \(currency.uppercased())",]) // transferer
                self.db.collection("users").document(transfereeUID).collection("transaction").addDocument(data: [
                    "type": type,
                    "transferer": Auth.auth().currentUser!.displayName!,
                    "transferee": transferee,
                    "time": Timestamp(date: Date()),
                    "amount": "\(amount) \(currency.uppercased())",]) // transferee
            }
        }
    }
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

