import UIKit
import Firebase
import FirebaseFirestore
import SwiftChart

class HomePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var currentBalanceCurrency: UIButton!
    @IBOutlet var savingBalanceCurrency: UIButton!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var savingBalance: UILabel!
    @IBOutlet weak var chartView: Chart!
    
    var db: Firestore!
    var toolBar = UIToolbar()
    var picker = UIPickerView()
    var selection:String = ""
    
    let currentUserID:String = Auth.auth().currentUser!.uid
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
        
//        for i in 0...4 {
//
//            let sevenDaysAgo = NSCalendar.current.date(byAdding: .day, value: -i, to: Date())
//            let dateFormatter = DateFormatter()
//            dateFormatter.timeStyle = DateFormatter.Style.none
//            dateFormatter.dateStyle = DateFormatter.Style.short
//            dateFormatter.dateFormat = "dd/MM/yy"
//
//            timeInterval.append(sevenDaysAgo!.timeIntervalSince1970)
//            print(dateFormatter.string(from: sevenDaysAgo!))
//
//        }
        
        let dataChart = [
            (x: 0, y: 0),
            (x: 1, y: 3.1),
            (x: 4, y: 2),
            (x: 5, y: -4.2),
            (x: 7, y: 5),
            (x: 9, y: 9),
            (x: 10, y: 8)
        ]
        let series = ChartSeries(data: dataChart)
        series.area = true
        
        chartView.add(series)
        
        self.navigationController?.isNavigationBarHidden = true
        nameLabel.text = Auth.auth().currentUser?.displayName ?? ""
        db = Firestore.firestore()
        var data = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        var data2 = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        var data3 = [String : Any](){
            didSet{
                DispatchQueue.main.async {
                    dataValueOnChange()
                }
            }
        };
        db.collection("users").document("\(currentUserID)").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document1: \(error!)")
                return
            }
            data = document.data()!
        }
        db.collection("users").document("\(self.currentUserID)").collection("balanceWallet")
        .document("currency").addSnapshotListener{ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document2: \(error!)")
                return
            }
            data2 = document.data()!
        }
        db.collection("users").document("\(self.currentUserID)").collection("balanceSaving")
        .document("currency").addSnapshotListener{ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching documents3: \(error!)")
                return
            }
            data3 = document.data()!
        }
        func dataValueOnChange(){
            if (!data.isEmpty && !data2.isEmpty && !data3.isEmpty){
                guard let walletCurrency:String = data["balanceWallet"] as? String else {
                    print("Error feteching currency Type")
                    return
                }
                print(walletCurrency)
                guard let walletAmount:Double = data2[walletCurrency.lowercased()] as? Double else {
                    print("Error feteching amount")
                    return
                }
                guard let savingCurrency:String = data["balanceSaving"] as? String else {
                    print("Error feteching currency Type")
                    return
                }
                guard let savingAmount:Double = data3[savingCurrency.lowercased()] as? Double else {
                    print("Error feteching amount")
                    return
                }
                self.currentBalance.text = String(format: "%.2f", walletAmount)
                self.currentBalanceCurrency.setTitle("\(walletCurrency.uppercased())", for: .normal)
                
                self.savingBalance.text = String(format: "%.2f", savingAmount)
                self.savingBalanceCurrency.setTitle("\(savingCurrency.uppercased())", for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    @IBAction func savingCurrencyOnClick(_ sender: Any) {
        savingDoneButtonTapped()
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
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(savingDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    @IBAction func currentCurrencyOnClick(_ sender: Any) {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
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
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(currentDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(false)
    }
    
    @objc func currentDoneButtonTapped() {
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
            "balanceWallet": selection.lowercased()
            ])
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    @objc func savingDoneButtonTapped() {
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
            "balanceSaving": selection.lowercased()
            ])
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @IBAction func paymentOnClick(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let QRScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: QRScanhandler)
        optionMenu.addAction(QRScanAction)
        let QRGenerateAction = UIAlertAction(title: "Generate QR", style: .default, handler: QRGeneratehandler)
        optionMenu.addAction(QRGenerateAction)
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
    func QRGeneratehandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toQRG", sender: nil)
    }
    func QRScanhandler(alert: UIAlertAction!){
        performSegue(withIdentifier: "toQR", sender: nil)
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

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
