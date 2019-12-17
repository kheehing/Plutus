import UIKit
import Firebase

class LoginViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var agreementLabel: UITextView!
    @IBOutlet weak var userNumber: UILabel!
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    //let token
    var TcTitle: String = ""
    var VerificationIdtoOTP:String = ""
    var phoneSignInBool: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if Auth.auth().currentUser != nil {
            print("toHome")
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NextButton.layer.cornerRadius = 5
        agreementLabel.textAlignment = NSTextAlignment.center
        self.setNotificationKeyboard()
        agreementLabel.isHidden = true
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        agreementLabel.delegate = self
        let attributedString = NSMutableAttributedString(string: "By Clicking Next, you agree to the Plutus Privacy Policy, Plutus Service Agreement & Plutus Terms and Conditions")
        attributedString.addAttribute(.link, value: "1", range: NSRange(location: 35, length: 21))
        attributedString.addAttribute(.link, value: "2", range: NSRange(location: 58, length: 24))
        attributedString.addAttribute(.link, value: "3", range: NSRange(location: 85, length: 27))
        agreementLabel.attributedText = attributedString
        
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.absoluteString == "1"){
            TcTitle = "Plutus Privacy Policy"
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else if (URL.absoluteString == "2"){
            TcTitle = "Plutus Service Agreement"
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else if (URL.absoluteString == "3"){
            TcTitle = "Plutus Terms and Conditions"
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTerms&Conditions"){
            let TcVC = segue.destination as! Terms_ConditionsViewController
            TcVC.titleText = TcTitle
        }
        if (segue.identifier == "toOTPFirstTimeUser"){
            let ToOTP = segue.destination as! OTPViewController
            ToOTP.number = TextField.text!
            ToOTP.verificationId = VerificationIdtoOTP
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 { scrollView.contentOffset.x = 0 }
    }
    
    func setNotificationKeyboard ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        agreementLabel.isHidden = false
        titleLabel.isHidden = true
        scrollView.isScrollEnabled = false
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        titleLabel.isHidden = false
        agreementLabel.isHidden = true
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func NextOnClick(_ sender: Any) {
        if !TextField.isFirstResponder{
            TextField.becomeFirstResponder()
        } else if TextField.text?.isEmpty ?? true{
                self.TextField.layer.borderColor = UIColor.red.cgColor
                self.TextField.layer.borderWidth = 1
                self.TextField.layer.cornerRadius = 5
        }
       /* else if (verificationID != nil){
            print("IF VERIFICATIONID IS NOT NIL: ",verificationID!)
        } */
        else {
            PhoneAuthProvider.provider().verifyPhoneNumber(
            self.TextField.text!,
            uiDelegate: nil){ (VerificationId, error) in
                if let error = error {
                    print("ERROR: ",error)
                    print("ERROR DESC: ",error.localizedDescription)
                    switch error.localizedDescription{
                        case "Invalid format.":
                            let alert = UIAlertController(title: "Invalid Phone Number", message: "Please check your phone number and make sure it is a valid number", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        case "We have blocked all requests from this device due to unusual activity. Try again later.":
                            let alert = UIAlertController(title: "Too Many Request", message: "We have blocked all requests from this device due to unusual activity. Try again later.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                    default:
                        return
                    }
                    return
                }
                UserDefaults.standard.set(VerificationId, forKey: "authVerificationID")
                self.VerificationIdtoOTP = VerificationId!
                self.performSegue(withIdentifier: "toOTPFirstTimeUser", sender: nil)
            }
        }
    }
}

