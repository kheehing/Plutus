import UIKit
import FirebaseFirestore

class topUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var typeOfTopUp: UITextField!
    @IBOutlet var typeOfTopUpPickerView: UIPickerView!
    
    var db: Firestore!
    var pickerData: [String] = [String]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.typeOfTopUpPickerView.addGestureRecognizer(tap)
        db = Firestore.firestore()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Top Up"
        self.typeOfTopUpPickerView.delegate = self
        self.typeOfTopUpPickerView.dataSource = self
        
        pickerData = [
            "CreditCard",
            "Bank Transfer",
        ]
        //tes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func typeOfTopUpTouchDown(_ sender: Any) {
        typeOfTopUpPickerView.isHidden = false
        typeOfTopUp.resignFirstResponder()
        typeOfTopUpPickerView.becomeFirstResponder()
    }

    @objc func pickerTapped(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            typeOfTopUpPickerView.isHidden = true
            typeOfTopUp.text = typeOfTopUpPickerView //selected row
            //let rowHeight = self.pickerView.rowSize(forComponent: 0).height
            //let selectedRowFrame = self.pickerView.bounds.insetBy(dx: 0, dy: (self.pickerView.frame.height - rowHeight) / 2)
            //let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.pickerView))
            //if userTappedOnSelectedRow {
            //    let selectedRow = self.pickerView.selectedRow(inComponent: 0)
            //    pickerView(self.pickerView, didSelectRow: selectedRow, inComponent: 0)
            //}
        }
    }
    
    func tes(){
        let lastHash = db.collection("transaction").document("lastTransaction")
        lastHash.getDocument{ (document,error) in
            if let document = document, document.exists {
                let lastHashDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Last Hash: \(lastHashDescription)")
            }
        }
    }

}
