//
//  AddExpViewController.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 9/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class AddExpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var addExp: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var budgetField: UITextField!
    
    let categories = ["Bills", "Transportation", "Food", "Entertainment", "Others"]
    var selectedCat: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCatPicker()
        budgetField.keyboardType = .numberPad
        addBtn.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func createCatPicker() {
        let catPicker = UIPickerView()
        catPicker.delegate = self
        categoryField.inputView = catPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([space, space, doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        categoryField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCat = categories[row]
        categoryField.text = selectedCat
    }

}
