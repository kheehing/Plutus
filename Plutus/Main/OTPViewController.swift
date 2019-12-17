import UIKit
import Firebase

class OTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet var textboxOne: UITextField!
    @IBOutlet var textboxTwo: UITextField!
    @IBOutlet var textboxThree: UITextField!
    @IBOutlet var textboxFour: UITextField!
    @IBOutlet var textboxFive: UITextField!
    @IBOutlet var textboxSix: UITextField!
    @IBOutlet var resendButton: UIButton!
    
    var verificationCode = "000000"
    var number: String = ""
    var verificationId: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textboxOne.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        /*print("textbox1: \(textboxOne.text!)")
        print("textbox2: \(textboxTwo.text!)")
        print("textbox3: \(textboxThree.text!)")
        print("textbox4: \(textboxFour.text!)")
        print("textbox5: \(textboxFive.text!)")
        print("textbox6: \(textboxFive.text!)")*/
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
            // user is signed in
            self.performSegue(withIdentifier: "toHomeOTP", sender: nil)
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        // Further handling of the device token if needed by the app
        // ...
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
        //disable the cut copy paste for the textbox 1-4
        // delete don't delete two box
        
        if (textField == textboxOne || textField == textboxTwo || textField == textboxThree || textField == textboxFour || textField == textboxFive || textField == textboxSix){
            let currentText = textField.text! + string
            return currentText.count <= 1
        }
        return true;
    }
    
}

