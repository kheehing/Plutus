import UIKit
import FirebaseFirestore
import Firebase

class ExchangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPickerView = pickerData[row]
        if (pickerView == fromPicker){
            print("frompickerView: \(selectedPickerView)")
            fromPickerValue = selectedPickerView
        } else {
            print("topickerView: \(selectedPickerView)")
            toPickerValue = selectedPickerView
        }
    }
    
    @IBOutlet weak var fromBefore: UILabel!
    @IBOutlet weak var toBefore: UILabel!
    @IBOutlet weak var fromAfter: UILabel!
    @IBOutlet weak var toAfter: UILabel!
    @IBOutlet var exchangeRateUS_SGD: UILabel!
    @IBOutlet var toPicker: UIPickerView!
    @IBOutlet var fromPicker: UIPickerView!
    @IBOutlet var toTextfield: UITextField!
    @IBOutlet var fromTextfield: UITextField!
    
    var exchangeRateUStoSGD:String = "" {
        didSet{
            DispatchQueue.main.async {
                self.exchangeRateUS_SGD.text = self.exchangeRateUStoSGD
            }
        }
    }
    
    var fromPickerValue:String = ""{
        didSet{
            DispatchQueue.main.async {
                self.pickerValueOnChange()
                if (!self.fromPickerValue.isEmpty){
                    guard let fromDB:Double = self.data2[self.fromPickerValue.lowercased()] as? Double else {
                        print("Error feteching fromDB")
                        return
                    }
                    self.fromBefore.text = String(format: "%.3f", fromDB)
                }
            }
        }
    };
    var toPickerValue:String = ""{
        didSet{
            DispatchQueue.main.async {
                self.pickerValueOnChange()
                if (!self.toPickerValue.isEmpty){
                    guard let fromDB:Double = self.data2[self.toPickerValue.lowercased()] as? Double else {
                        print("Error feteching fromDB")
                        return
                    }
                    self.toBefore.text = String(format: "%.3f", fromDB)
                }
            }
        }
    };
    var data2 = [String : Any](){
        didSet{
            DispatchQueue.main.async {
                print(self.data2)
                if (!self.toPickerValue.isEmpty){
                    guard let fromDB:Double = self.data2[self.toPickerValue.lowercased()] as? Double else {
                        print("Error feteching fromDB")
                        return
                    }
                    self.toBefore.text = String(format: "%.3f", fromDB)
                }
                if (!self.fromPickerValue.isEmpty){
                    guard let fromDB:Double = self.data2[self.fromPickerValue.lowercased()] as? Double else {
                        print("Error feteching fromDB")
                        return
                    }
                    self.fromBefore.text = String(format: "%.3f", fromDB)
                }
            }
        }
    };
    var someDouble:Double = 0
    var db: Firestore!

    let pickerData = [
        "SGD",
        "USD",
    ]
    
    struct currency: Codable {
        let rates: [String:Decimal];
        let base: String;
        let date: String;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromPickerValue = ""
        toPickerValue = ""
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Exchange"
        self.toPicker.delegate = self
        self.toPicker.dataSource = self
        self.fromPicker.delegate = self
        self.fromPicker.dataSource = self
        db = Firestore.firestore()
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet")
            .document("currency").addSnapshotListener{ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document2: \(error!)")
                    return
                }
                self.data2 = document.data()!
        }
        fromTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        toTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if let url = URL(string: "https://api.exchangeratesapi.io/latest") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Whole String",jsonString)
                    }
                    do {
                        let res = try JSONDecoder().decode(currency.self, from: data)
                        let value:Decimal = res.rates["SGD"]! / res.rates["USD"]!
                        let someDouble = Double(truncating: value as NSNumber).roundTo(places: 3)
                        self.someDouble = someDouble
                        self.exchangeRateUStoSGD = "USD : SGD     1 : \(someDouble)"
                        print("US:SGD: 1:\(res.rates["SGD"]! / res.rates["USD"]!)")
                        print("date: ",res.date)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.absoluteString == "1"){
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else {
            return false
        }
    }
    
    @IBAction func exchangeOnClick(_ sender: Any) {
        if (fromPickerValue.isEmpty || toPickerValue.isEmpty){
            alert(title: "Error", message: "Please reset the Currency PickerView")
        } else if (fromPickerValue == toPickerValue){
            alert(title: "Error", message: "You can't exchange the same currency")
        } else if (fromTextfield.text!.isEmpty || toTextfield.text!.isEmpty){
            alert(title: "Error", message: "Amount Field(s) should not be Empty")
        } else { db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let sData = snapshot!.data()!
                    let fromAmountType = self.fromPickerValue.lowercased()
                    let toAmountType = self.toPickerValue.lowercased()
                    let amountBank:Double  = sData["\(self.fromPickerValue.lowercased())"]! as! Double
                    let amountEntered:Double = Double(self.fromTextfield.text!)!
                    let amountCalculated:Double = Double(self.toTextfield.text!)!
                    print(amountBank)
                    print(amountEntered)
                    if (amountBank < amountEntered) {
                        self.alert(title: "Invalid number", message: "You bank doesn't have $\(amountEntered) \(self.fromPickerValue), \nit only has $\(amountBank) \(self.fromPickerValue.uppercased()).")
                    } else {
                        self.db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (Tsnapshot,err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print(Tsnapshot!.data()!)
                                print(snapshot!.data()!)
                                print(self.someDouble)
                                self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "\(fromAmountType)" : snapshot!.data()![fromAmountType] as! Double - amountEntered ]) // from
                                self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "\(toAmountType)" : snapshot!.data()![toAmountType] as! Double + amountCalculated ]) // to
                                self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("transaction").addDocument(data: [
                                    "type": "Exchange",
                                    "user": "\(Auth.auth().currentUser!.displayName!)",
                                    "time": Timestamp(date: Date()),
                                    "fromAmount": "\(amountEntered) \(fromAmountType.uppercased())",
                                    "toAmount": "\(amountCalculated) \(toAmountType.uppercased())",]) // transaction
                                    }
                                }
                            }
                        }
//                        print("bank: \(amountBank)")
//                        print("entered: \(amountEntered )")
                    }
                }
            }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let regexPattern = "[0-9]*"
        let result = fromTextfield.text!.range(of: regexPattern,options: .regularExpression)
        if (result != nil){
            if (fromTextfield.text!.isEmpty && toTextfield.text!.isEmpty){
                fromTextfield.isUserInteractionEnabled = true
                toTextfield.isUserInteractionEnabled = true
            } else if (fromTextfield.isFirstResponder){
                if (fromTextfield.text!.isEmpty){
                    toTextfield.text! = ""
                    resetLabel()
                    toTextfield.isUserInteractionEnabled = true
                } else if (fromTextfield.text!.prefix(1) == "-"){
                    print("\(fromTextfield.text!.prefix(1))")
                    alert(title: "Error", message: "Numbers cannot be negative")
                } else if (!fromTextfield.text!.isEmpty){
                    checkExchange()
                    toTextfield.isUserInteractionEnabled = false
                }
            } else if (toTextfield.isFirstResponder){
                if (toTextfield.text!.isEmpty){
                    fromTextfield.text! = ""
                    resetLabel()
                    fromTextfield.isUserInteractionEnabled = true
                } else if (Int(toTextfield.text!)! < 0){
                    alert(title: "Error", message: "Numbers cannot be negative")
                } else if (!toTextfield.text!.isEmpty) {
                    checkExchange()
                    fromTextfield.isUserInteractionEnabled = false
                }
            }
            
        }
    }
    
    func resetLabel(){
        toAfter.text = ""
        fromAfter.text = ""
    }
    
    func pickerValueOnChange(){
        if (!toPickerValue.isEmpty || !self.fromPickerValue.isEmpty){
            if (fromPickerValue != toPickerValue){
                if (fromTextfield.isUserInteractionEnabled == true && toTextfield.isUserInteractionEnabled == false){
                    if (fromPickerValue.lowercased() == "sgd"){
                        var value:Double = (someDouble * Double(fromTextfield.text!)!)
                        value = value.roundTo(places: 3)
                        toTextfield.text = "\(value)"
                        self.checkExchange()
                    } else {
                        var value:Double = ((1/someDouble) * Double(fromTextfield.text!)!)
                        value = value.roundTo(places: 3)
                        toTextfield.text = "\(value)"
                        self.checkExchange()
                    }
                } else if (toTextfield.isUserInteractionEnabled == true && fromTextfield.isUserInteractionEnabled == false){
                    if (toPickerValue.lowercased() == "sgd"){
                        var value:Double = (someDouble / Double(toTextfield.text!)!)
                        value = value.roundTo(places: 3)
                        fromTextfield.text = "\(value)"
                        self.checkExchange()
                    } else {
                        var value:Double = ((1/someDouble) * Double(toTextfield.text!)!)
                        value = value.roundTo(places: 3)
                        fromTextfield.text = "\(value)"
                        self.checkExchange()
                    }
                }
            }
        }
    }
    
    func checkExchange(){
        func cal(_ value:Double,_ Type:Bool){
            if (!toBefore.text!.isEmpty && !fromBefore.text!.isEmpty) {
                guard let toDB:Double = self.data2[self.toPickerValue.lowercased()] as? Double else {
                    print("Error feteching fromDB")
                    return
                }
                guard let fromDB:Double = self.data2[self.fromPickerValue.lowercased()] as? Double else {
                    print("Error feteching fromDB")
                    return
                }
                if (Type){
                    toAfter.text = String(format: "%.3f", toDB + value)
                    fromAfter.text = String(format: "%.3f", fromDB - Double(fromTextfield.text!)!)
                } else {
                    toAfter.text = String(format: "%.3f", toDB + Double(toTextfield.text!)!)
                    fromAfter.text = String(format: "%.3f", fromDB - value)
                }
            }
        }
        if (fromTextfield.isFirstResponder){
            if (fromPickerValue.lowercased() == "sgd"){
                let value:Double = (someDouble * Double(fromTextfield.text!)!)
                toTextfield.text = String(format: "%.3f", value)
                cal(value,true)
            } else {
                let value:Double = (Double(fromTextfield.text!)! / someDouble)
                toTextfield.text = String(format: "%.3f", value)
                cal(value,true)
            }
        } else if (toTextfield.isFirstResponder){
            if (toPickerValue.lowercased() == "sgd"){
                let value:Double = (Double(toTextfield.text!)! / someDouble)
                fromTextfield.text = String(format: "%.3f", value)
                cal(value,false)
            } else {
                let value:Double = (someDouble * Double(toTextfield.text!)!)
                fromTextfield.text = String(format: "%.3f", value)
                cal(value,false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
