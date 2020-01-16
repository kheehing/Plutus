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
    @IBAction func paymentOnClick(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let transferAction = UIAlertAction(title: "QR scan", style: .default, handler: QRhandler)
        optionMenu.addAction(transferAction)
        let topupAction = UIAlertAction(title: "NFS", style: .default, handler: NFShandler)
        optionMenu.addAction(topupAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    @IBAction func manageOnClick(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let transferAction = UIAlertAction(title: "Transfer", style: .default, handler: transferhandler)
        optionMenu.addAction(transferAction)
        let topupAction = UIAlertAction(title: "Top Up", style: .default, handler: topuphandler)
        optionMenu.addAction(topupAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    func QRhandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toQR", sender: nil)
    }
    func NFShandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toNFS", sender: nil)
    }
    func transferhandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toTransfer", sender: nil)
    }
    func topuphandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toTopUp", sender: nil)
    }
    
}
