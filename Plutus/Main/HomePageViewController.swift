import UIKit
import Firebase

class HomePageViewController: UIViewController {
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let currentUser = Auth.auth().currentUser
        nameLabel.text = currentUser?.phoneNumber!
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
