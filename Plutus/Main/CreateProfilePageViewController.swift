import UIKit
import FirebaseFirestore
import Firebase

class CreateProfilePageViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    @IBOutlet var scollView: UIScrollView!
    @IBOutlet var InputFirstname: UITextField!
    @IBOutlet var InputLastname: UITextField!
    @IBOutlet var InputEmail: UITextField!
    @IBOutlet var bottomTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomTextView.alpha = 0.0
        self.navigationController?.isNavigationBarHidden = true
        submitButton.isEnabled = false
        db = Firestore.firestore()
        InputFirstname.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        InputLastname.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
        InputEmail.addTarget(self, action: #selector(self.textFieldIsNotEmpty(textField:)), for: UIControl.Event.editingChanged)
    }

    @objc private func textFieldIsNotEmpty(textField: UITextField){
        if (InputFirstname.text?.isEmpty)! || (InputLastname.text?.isEmpty)! || (InputEmail.text?.isEmpty)! {
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
    
    @IBAction func SubmitOnClick(_ sender: Any) {
        if self.bottomTextView.alpha == 0.0 {
            UIView.animate(withDuration: 0.0, delay: 0,options: .curveEaseIn, animations: {
             self.bottomTextView.alpha = 1.0
            })
            UIView.animate(withDuration: 0.5, delay: 3,options: .curveEaseOut, animations: {
                self.bottomTextView.alpha = 0.0
            })
        } else {
            UIView.animate(withDuration: 0.0, delay: 0,options: .curveEaseOut, animations: {
                self.bottomTextView.alpha = 0.0
            })
        }
        var warningText:String = ""
        var isError:Bool = false
        if isValidEmail(InputEmail.text!) == false {
            print("invalid email format")
            warningText += "\n Invalid Email Format"
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
                "email" : "\(InputEmail.text!)",
                "firstName" : "\(InputFirstname.text!)",
                "lastName" : "\(InputLastname.text!)",
                "mobileNumber" : "\((Auth.auth().currentUser?.phoneNumber)!)",
                "balanceWallet" : 0,
                "balanceSaving" : 0,
                "transcation" : []
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                }
            }
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func BackOnClick(_ sender: Any) {
    }
}
