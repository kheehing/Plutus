import UIKit
import FirebaseFirestore

class topUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet var typeOfTopUp: UITextField!
    @IBOutlet var typeOfTopUpPickerView: UIPickerView!
    
    var db: Firestore!
    
    let pickerData = [
    "CreditCard",
    "Paypal",
    ]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Top Up"
        createCatPicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true}
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPickerView = pickerData[row]
        typeOfTopUp.text = selectedPickerView
    }
    
    func createCatPicker() {
        let catPicker = UIPickerView()
        catPicker.delegate = self
        typeOfTopUp.delegate = self
        typeOfTopUp.inputView = catPicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([space, space, doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        typeOfTopUp.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
