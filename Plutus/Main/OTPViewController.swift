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
    var verificationId: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textboxOne.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNumber?.text = number
        textboxOne.delegate = self
        textboxTwo.delegate = self
        textboxThree.delegate = self
        textboxFour.delegate = self
        
        textboxOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textboxFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        print("VerificationID: ",verificationId)
    }
    
    @IBAction func resendOnClick(_ sender: Any) {
        print("textbox1: \(textboxOne.text!)")
        print("textbox2: \(textboxTwo.text!)")
        print("textbox3: \(textboxThree.text!)")
        print("textbox4: \(textboxFour.text!)")
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        
        if text?.utf16.count == 1{
            switch textField{
            case textboxOne:
                textboxTwo.becomeFirstResponder()
            case textboxTwo:
                textboxThree.becomeFirstResponder()
            case textboxThree:
                textboxFour.becomeFirstResponder()
            case textboxFour:
                textboxFour.resignFirstResponder()
                // check with db
            default:
                break
            }
        } else {
            
        }
    }
    
    func verifyOtp(){
        
    }
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //disable the cut copy paste for the textbox 1-4
        // delete don't delete two box
        
        if (textField == textboxOne || textField == textboxTwo || textField == textboxThree || textField == textboxFour){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        return true;
    }
    
}
