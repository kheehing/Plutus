//
//  OTPViewController.swift
//  Plutus
//
//  Created by ITP312 on 5/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet var textboxOne: UITextField!
    @IBOutlet var textboxTwo: UITextField!
    @IBOutlet var textboxThree: UITextField!
    @IBOutlet var textboxFour: UITextField!
    @IBOutlet var resendButton: UIButton!
    
    var maxLen:Int = 1;
    var number: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNumber?.text = number
        textboxOne.delegate = self
        textboxTwo.delegate = self
        textboxThree.delegate = self
        textboxFour.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resendOnClick(_ sender: Any) {
        print("textbox1: \(textboxOne.text!)")
        print("textbox2: \(textboxTwo.text!)")
        print("textbox3: \(textboxThree.text!)")
        print("textbox4: \(textboxFour.text!)")
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        //disable the cut copy paste for the textbox 1-4
        // delete don't delete two box
        
        if (textField == textboxOne || textField == textboxTwo || textField == textboxThree || textField == textboxFour){
            let currentText = textField.text! + string
            if (textField == textboxOne && textField.text!.count <= maxLen){
                textField.text! = string
                textboxTwo.becomeFirstResponder()
            } else if (textField == textboxTwo && textField.text!.count <= maxLen){
                textField.text! = string
                textboxThree.becomeFirstResponder()
            } else if (textField == textboxThree && textField.text!.count <= maxLen){
                textField.text! = string
                textboxFour.becomeFirstResponder()
            } else if (textField == textboxFour && textField.text!.count <= maxLen){
                if textField.text! == "" && string == ""{
                    textboxThree.becomeFirstResponder()
                }else {
                    textField.text! = string
                    textboxFour.resignFirstResponder()
                }
            }
            return currentText.count <= maxLen
        }
        return true;
    }
    
    
}
