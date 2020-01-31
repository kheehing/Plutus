//
//  ExchangeViewController.swift
//  Plutus
//
//  Created by ITP312 on 31/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
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
    
    let picerData = [
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
        
        
        
        if let url = URL(string: "https://api.exchangeratesapi.io/latest") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Whole String",jsonString)
                    }
                    
                    do {
                        let res = try JSONDecoder().decode(currency.self, from: data)
//                        print("US rates: ",res.rates["USD"]!)
//                        print("SG rates: ",res.rates["SGD"]!)
//                        print("base: ",res.base)
                        let value:Decimal = res.rates["SGD"]! / res.rates["USD"]!
                        let someDouble = Double(truncating: value as NSNumber).roundTo(places: 3)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
