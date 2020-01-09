import UIKit
import FirebaseFirestore
import Firebase

class CreateProfilePageViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    @IBOutlet var scollView: UIScrollView!
    @IBOutlet var InputFirstname: UITextField!
    @IBOutlet var InputLastname: UITextField!
    @IBOutlet var InputEmail: UITextField!
    @IBOutlet var InputPassword: UITextField!
    @IBOutlet var InputPassword2: UITextField!
    @IBOutlet var bottomTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        submitButton.isEnabled = false
        InputPassword.textContentType = .newPassword
        InputPassword2.textContentType = .newPassword
        db = Firestore.firestore()
        self.setNotificationKeyboard()
        scollView.delegate = self
        if #available(iOS 11.0, *) {
            scollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        InputFirstname.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        InputLastname.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        InputEmail.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        InputPassword.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        InputPassword2.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        
        InputPassword.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        InputPassword2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
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
        scollView.isScrollEnabled = false
        self.scollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        var contentInset:UIEdgeInsets = self.scollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    @objc private func textFieldDidChange(textField: UITextField){
        if textField == InputPassword2 {
            if InputPassword2.text! != InputPassword.text!{
                InputPassword2.layer.borderColor = UIColor.red.cgColor
                InputPassword2.layer.borderWidth = 1
                InputPassword2.layer.cornerRadius = 5
            } else {
                InputPassword2.layer.borderColor = UIColor.black.cgColor
                InputPassword2.layer.borderWidth = 0
                InputPassword2.layer.cornerRadius = 0
            }
        } else if InputPassword2.layer.borderColor == UIColor.yellow.cgColor && InputPassword2.text! == InputPassword.text! {
            InputPassword2.layer.borderColor = UIColor.black.cgColor
            InputPassword2.layer.borderWidth = 0
            InputPassword2.layer.cornerRadius = 0
        }
    }
    @objc private func textFieldIsNotEmpty(textField: UITextField){
        if (InputFirstname.text?.isEmpty)! || (InputLastname.text?.isEmpty)! || (InputEmail.text?.isEmpty)! || (InputPassword.text?.isEmpty)! || (InputPassword2.text?.isEmpty)!{
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
    
    @IBAction func SubmitOnClick(_ sender: Any) {
        var warningText:String = ""
        var isError:Bool = false
        if InputPassword.text! != InputPassword2.text! {
            warningText += "Password does not match"
            isError = true
        }
        bottomTextView.text! = warningText
        if (isError == false) {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(InputFirstname.text!) \(InputLastname.text!)"
            changeRequest?.commitChanges { (error) in
                if (error != nil) {
                    print("changeRequest Error: \(error!.localizedDescription)")
                }
            }
            let usersRef = db.collection("users")
            usersRef.document("uid").updateData([ "uid": FieldValue.arrayUnion(["\(Auth.auth().currentUser!.uid)"]) ])
            usersRef.document("\(Auth.auth().currentUser!.uid)").setData([
                "Email":"hi"
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        } else if (isError == true){
            print("password does not match")
        }
    }
    
    @IBAction func BackOnClick(_ sender: Any) {
    }
}
