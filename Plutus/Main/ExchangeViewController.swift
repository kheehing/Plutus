//
//  ExchangeViewController.swift
//  Plutus
//
//  Created by ITP312 on 31/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

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
    
    var fromPickerValue:String = "";
    var toPickerValue:String = "";
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
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Exchange"
        self.toPicker.delegate = self
        self.toPicker.dataSource = self
        self.fromPicker.delegate = self
        self.fromPicker.dataSource = self
        toTextfield.isUserInteractionEnabled = false
        db = Firestore.firestore()
        fromTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
        } else {
            db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let sData = snapshot!.data()!
                    //let fromAmountType = self.fromPickerValue
                    //let toAmountType = self.toPickerValue
                    let amountBank = sData["\(self.fromPickerValue)"]!
                    let amountEntered:Int = Int(self.fromTextfield.text!)!
                    if (Int("\(amountBank)")! < Int(amountEntered)) {
                        self.alert(title: "Invalid number", message: "You bank doesn't have $\(amountEntered) \(self.fromPickerValue), \nit only has $\(amountBank) \(self.fromPickerValue.uppercased()).")
                    } else {
                        self.db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (Tsnapshot,err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print(Tsnapshot!.data()!)
                                print(snapshot!.data()!)
                                print(self.someDouble)
//                               self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "sgd" : snapshot!.data()![amountType] as! Int - amountEntered ]) // transferer
//                                self.db.collection("users").document(document.documentID).collection("balanceWallet").document("currency").updateData([ "sgd" : snapshott!.data()![amountType] as! Int + amountEntered ]) // transferee
//                                self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("transaction").addDocument(data: [
//                                    "type": "transfer",
//                                    "transferer": Auth.auth().currentUser!.displayName!,
//                                    "transferee": "\(document.data()["firstName"]!) \(document.data()["lastName"]!)",
//                                    "time": Timestamp(date: Date()),
//                                    "amount": "\(amountEntered) \(amountType.uppercased())",]) // transferer
//                                self.db.collection("users").document(document.documentID).collection("transaction").addDocument(data: [
//                                    "type": "transfer",
//                                    "transferer": Auth.auth().currentUser!.displayName!,
//                                    "transferee": "\(document.data()["firstName"]!) \(document.data()["lastName"]!)",
//                                    "time": Timestamp(date: Date()),
//                                    "amount": "\(amountEntered) \(amountType.uppercased())",]) // transferer
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
        if (!fromTextfield.text!.isEmpty){
            let regexPattern = "[0-9]*"
            let result = fromTextfield.text!.range(of: regexPattern,options: .regularExpression)
            if (result != nil){
                let value:Double = (someDouble * Double(fromTextfield.text!)!).roundTo(places: 3)
                toTextfield.text = "\(value)"
            } else {
                print("nil")
            }
        } else {
            toTextfield.text = ""
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

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
