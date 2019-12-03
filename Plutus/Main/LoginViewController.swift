//
//  LoginViewController.swift
//  Plutus
//
//  Created by ITP312 on 28/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import Hero

class LoginViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var agreementLabel: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        agreementLabel.textAlignment = NSTextAlignment.center
        self.setNotificationKeyboard()
        agreementLabel.isHidden = true
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agreementLabel.delegate = self
        let attributedString = NSMutableAttributedString(string: "By Clicking Next, you agree to the Plutus Privacy Policy, Plutus Service Agreement & Plutus Terms and Conditions")
        attributedString.addAttribute(.link, value: "1", range: NSRange(location: 35, length: 21))
        attributedString.addAttribute(.link, value: "2", range: NSRange(location: 58, length: 24))
        attributedString.addAttribute(.link, value: "3", range: NSRange(location: 85, length: 27))
        agreementLabel.attributedText = attributedString
    }
    
    var TcTitle: String = ""
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.absoluteString == "1"){
            TcTitle = "Plutus Privacy Policy"
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else if (URL.absoluteString == "2"){
            TcTitle = "Plutus Service Agreement"
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else if (URL.absoluteString == "3"){
            TcTitle = "Plutus Terms and Conditions"
            self.performSegue(withIdentifier: "toTerms&Conditions", sender: nil)
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTerms&Conditions"){
            let TcVC = segue.destination as! Terms_ConditionsViewController
            TcVC.titleText = TcTitle
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 { scrollView.contentOffset.x = 0 }
    }
    // Notification when keyboard show
    func setNotificationKeyboard ()  {
        // setup keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        agreementLabel.isHidden = false
        titleLabel.isHidden = true
        scrollView.isScrollEnabled = false
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        titleLabel.isHidden = false
        agreementLabel.isHidden = true
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    
}
