import UIKit
import Firebase
import FirebaseFirestore

class OTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet var textboxOne: UITextField!
    @IBOutlet var textboxTwo: UITextField!
    @IBOutlet var textboxThree: UITextField!
    @IBOutlet var textboxFour: UITextField!
    @IBOutlet var textboxFive: UITextField!
    @IBOutlet var textboxSix: UITextField!
    @IBOutlet var resendButton: UIButton!
    
    var db: Firestore!
    var verificationCode = "000000"
    var number: String = ""
    var verificationId: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textboxOne.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        db = Firestore.firestore()
        userNumber?.text = number
        textboxOne.delegate = self
        textboxTwo.delegate = self
        textboxThree.delegate = self
        textboxFour.delegate = self
        textboxFive.delegate = self
        textboxSix.delegate = self
        
        textboxOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxFive.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxSix.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        print("VerificationID: ",verificationId)
    }
    
    @IBAction func resendOnClick(_ sender: Any) {
        print("Combined textbox: \(textboxOne.text!)\(textboxTwo.text!)\(textboxThree.text!)\(textboxFour.text!)\(textboxFive.text!)\(textboxSix.text!)")
        verifyOtp()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        
        if text?.utf16.count == 1{
            switch textField{
            case textboxOne:
                textboxTwo.becomeFirstResponder()
            case textboxTwo:
                textboxThree.becomeFirstResponder()
            case textboxThree:
                textboxFour.becomeFirstResponder()
            case textboxFour:
                textboxFive.becomeFirstResponder()
            case textboxFive:
                textboxSix.becomeFirstResponder()
            case textboxSix:
                textboxSix.resignFirstResponder()
                verifyOtp()
            default:
                break
            }
        }
    }
    
    func verifyOtp(){
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: "\(textboxOne.text!)\(textboxTwo.text!)\(textboxThree.text!)\(textboxFour.text!)\(textboxFive.text!)\(textboxSix.text!)")
        Auth.auth().signIn(with: credential){ (AuthResult, error) in
            if let error = error {
                print("ERROR: ",error)
                print("ERROR DESC: ",error.localizedDescription)
                return
            }
//             user is signed in
            self.db.collection("users").document("uid").getDocument {(document, error) in
                if let document = document {
                    let uidList = document["uid"] as! Array<String>
                    if uidList.contains("\(Auth.auth().currentUser!.uid)"){
                        self.performSegue(withIdentifier: "toHomeOTP", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "toCreateProfilePage", sender: nil)
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == textboxOne || textField == textboxTwo || textField == textboxThree || textField == textboxFour || textField == textboxFive || textField == textboxSix){
            let currentText = textField.text! + string
            return currentText.count <= 1
        }
        return true;
    }
}
