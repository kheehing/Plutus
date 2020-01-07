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
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.setNotificationKeyboard()
        scollView.delegate = self
        if #available(iOS 11.0, *) {
            scollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
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
    
    @IBAction func SubmitOnClick(_ sender: Any) {
        var warningText:String = ""
        var isError:Bool = false
        if (InputFirstname.text?.isEmpty)! {
            warningText += "\n Firstname should not be empty"
            isError = true
        }
        if (InputLastname.text?.isEmpty)! {
            warningText += "\n Lastname should not be empty"
            isError = true
        }
        if (InputEmail.text?.isEmpty)! {
            warningText += "\n Email should not be empty"
            isError = true
        }
        if (InputPassword.text?.isEmpty)! {
            warningText += "\n Password should not be empty"
            isError = true
        }
        if (InputPassword2.text?.isEmpty)! {
            warningText += "\n Please retype your password"
            isError = true
        }
        if InputPassword.text! != InputPassword2.text! {
            warningText += "\n Password does not match"
            isError = true
        }
        bottomTextView.text! = warningText
        if (isError == false) {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(InputFirstname.text!) \(InputLastname.text!)"
            changeRequest?.commitChanges { (error) in
                print("changeRequest Error: \(error!)")
            }
            let usersRef = db.collection("users").document("uid")
            usersRef.updateData([ "uid": FieldValue.arrayUnion(["\(Auth.auth().currentUser!.uid)"]) ])
        }
    }
    
    @IBAction func BackOnClick(_ sender: Any) {
    }
}
