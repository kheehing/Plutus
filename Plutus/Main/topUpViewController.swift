import UIKit
import Braintree
import FirebaseFirestore
import Firebase

class topUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var textfield: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var button: UIButton!
    @IBOutlet var textView: UITextView!
    
    var braintreeClient: BTAPIClient!
    var pickerViewSelection:String = "SGD"
    var db: Firestore!
    
    let pickerData = [
        "SGD",
        "USD",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        braintreeClient = BTAPIClient(authorization: "sandbox_w3ry6mkv_dqz5p667pcwdq44y")!
        self.title = "PayPal TopUp"
    }
    
    func startCheckout(amount:String,currency:String) {
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self
        
        let request = BTPayPalRequest(amount: amount)
        request.currencyCode = currency
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                self.addtheMONEYY(amount: amount, currency: currency)
//                Access additional information
//                let email = tokenizedPayPalAccount.email
//                let firstName = tokenizedPayPalAccount.firstName
//                let lastName = tokenizedPayPalAccount.lastName
//                let phone = tokenizedPayPalAccount.phone
                
//                See BTPostalAddress.h for details
//                let billingAddress = tokenizedPayPalAccount.billingAddress
//                let shippingAddress = tokenizedPayPalAccount.shippingAddres
                // function that add and minus money
            } else if let error = error {
                // Handle error here...
                print("Error: \(error)")
            } else {
                // Buyer canceled payment approval
                print("Cancelled payment")
            }
        }
    }
    
    func addtheMONEYY(amount:String,currency:String){
        print("addtheMONEYY")
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").getDocument(){ (document, error) in
            if let document = document {
                let amount:Double = Double(amount)!
                let currentmoney:Double = Double(document.data()![currency.lowercased()]! as! NSNumber)
                let newMoney:Double = currentmoney + amount
                print(amount)
                print(currentmoney)
                print(newMoney)
                let Ref = self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency")
                Ref.updateData([
                    currency.lowercased() : newMoney
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                print("document does not exist")
            }
            if let error = error {
                print("Error: \(error)")
            }
        }
        
    }
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func SubmitOnClick(_ sender: Any) {
        if (textfield.text!.isEmpty){
            alert(title: "Error", message: "Amount Cannot be Empty")
        } else {
            print(textfield.text!)
            print(pickerViewSelection)
            startCheckout(amount: "\(textfield.text!)", currency: pickerViewSelection)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPickerView = pickerData[row]
        self.pickerViewSelection = "\(selectedPickerView)"
        print("pickerView: \(selectedPickerView)")
    }
    
}

extension topUpViewController : BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension topUpViewController : BTAppSwitchDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        //showLoadingUI()
        //NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        //hideLoadingUI()
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
    }
}
