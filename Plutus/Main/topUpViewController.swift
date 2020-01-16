import UIKit
import FirebaseFirestore

class topUpViewController: UIViewController {
    @IBOutlet var typeOfTopUp: UITextField!
    @IBOutlet var typeOfTopUpPickerView: UIPickerView!
    
    var db: Firestore!
    var previousHash: String = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Top Up"
        tes()
    }
    
    func tes(){
        let transactionRef = db.collection("transaction")
        transactionRef.limit(to: 1).getDocuments{ (QuerySnapshot, error) in
            if let snapshot = QuerySnapshot {
                for document in snapshot.documents{
                    let data = document.data()
                    self.previousHash = "\(data["hashPrevious"]!)"
                }
            }
            if let error = error {
                print("Error getting Documents: \(error.localizedDescription)")
                return
            }
        }
    }

}
