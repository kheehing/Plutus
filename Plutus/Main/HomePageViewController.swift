import UIKit
import Firebase
import FirebaseFirestore

class HomePageViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var savingBalance: UILabel!
    
    var db: Firestore!
    let currentUserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        nameLabel.text = Auth.auth().currentUser?.displayName! ?? ""
        db = Firestore.firestore()
        db.collection("users").document("\(currentUserID ?? "")").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self.currentBalance.text = "\(data["balanceWallet"] ?? 0)"
            self.savingBalance.text = "\(data["balanceSaving"] ?? 0)"
            print("Current data: \(data)")
        }
    }

    
    @IBAction func SignOutOnClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        Auth.auth().addIDTokenDidChangeListener{(auth, user) in
            if Auth.auth().currentUser == nil{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
