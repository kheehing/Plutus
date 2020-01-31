import UIKit
import Firebase
import FirebaseFirestore

class HomePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var currentBalanceCurrency: UIButton!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var savingBalance: UILabel!
    
    var db: Firestore!
    var toolBar = UIToolbar()
    var picker = UIPickerView()
    var selection:String = ""
    
    let currentUserID = Auth.auth().currentUser?.uid
    let pickerData = [
        "SGD",
        "USD",
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPickerView = pickerData[row]
        self.selection = selectedPickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        nameLabel.text = Auth.auth().currentUser?.displayName ?? ""
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
            self.db.collection("users").document("\(self.currentUserID ?? "")").collection("balanceWallet").document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data2 = document.data() else {
                    print("Document data was empty.")
                    return
                }
                guard let currency:String = data["balanceWallet"] as? String else {
                    print("Error feteching currency Type")
                    return
                }
                guard let amount = data2[currency] else {
                    print("Error feteching currency Type")
                    return
                }
                self.currentBalance.text = "\(amount)"
                self.currentBalanceCurrency.setTitle("\(currency.uppercased())", for: .normal)
            }
            self.savingBalance.text = "\(data["balanceSaving"] ?? 0)"
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
    
    @IBAction func CurrencyOnClick(_ sender: Any) {
        onDoneButtonTapped()
        dismissKeyboard()
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(false)
    }
    
    @objc func onDoneButtonTapped() {
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
            "balanceWallet": selection.lowercased()
            ])
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
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
        let exchangeAction = UIAlertAction(title: "Exchange", style: .default, handler: exchangehandler)
        optionMenu.addAction(exchangeAction)
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
    func exchangehandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toExchange", sender: nil) // add new controller
    }
    func topuphandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toTopUp", sender: nil)
    }
    
}
