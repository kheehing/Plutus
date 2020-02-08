//
//  QRGViewController.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 9/2/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class QRGViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var generateButton: UIButton!
    
    var curValue:String = "SGD"
    var catValue:String = "Bills"
    
    let catData = [
    "Bills",
    "Entertainment",
    "Food",
    "Transportation",
    "Others"]
    
    let curData = [
    "SGD",
    "USD"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == currencyPicker){
        return curData.count
    } else {
        return catData.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == currencyPicker){
            return curData[row]
        } else {
            return catData[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == currencyPicker) {
            let selectedValue = curData[row]
            self.curValue = selectedValue
        } else if (pickerView == categoryPicker) {
            let selectedValue = catData[row]
            self.catValue = selectedValue
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Generate QR"
        self.hideKeyboardWhenTappedAround()
        categoryPicker.delegate = self
        currencyPicker.delegate = self
    }

    @IBAction func GenerateOnClick(_ sender: Any) {
        if (amountTextField.text!.isEmpty){
            alert(title: "Empty Fields", message: "Amount field cannot be left Empty")
        } else {
            self.performSegue(withIdentifier: "QRImage", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QRImage"){
            let QRI = segue.destination as! QRImageViewController
            QRI.amount = Int(amountTextField.text!)!
            QRI.currency = curValue
            QRI.category = catValue
        }
    }
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
