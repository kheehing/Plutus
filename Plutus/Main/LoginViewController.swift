//
//  LoginViewController.swift
//  Plutus
//
//  Created by ITP312 on 28/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import FRHyperLabel

class LoginViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var agreementLabel: FRHyperLabel!
    
    
    //TextField.delegate = self
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setNotificationKeyboard()
        scrollView.delegate = self
        // agreementLabel.isHidden = true
        if #available(iOS 11.0, *){
            scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let agreementLabelString = "By Clicking Next, you agree to the Plutus Privacy Policy, Plutus Service Agreement & Plutus Terms and Conditions"
        
        let agreementLabelAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        
        agreementLabel.attributedText = NSAttributedString(
            string: agreementLabelString,
            attributes: agreementLabelAttributes)
        
        let agreementLabelHalder = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            let controller = UIAlertController(title: substring, message: nil, preferredStyle: UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
        
        agreementLabel.setLinksForSubstrings(
            ["Plutus Privacy Policy", "Plutus Service Agreement", "Plutus Terms and Conditions"],
            withLinkHandler: agreementLabelHalder)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
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
        
        titleLabel.isHidden = true
        scrollView.isScrollEnabled = false
        self.scrollView.setContentOffset(
            CGPoint(x: 0, y: 200),
            animated: true)
        // agreementLabel.isHidden = false
        var contentInset:UIEdgeInsets = self.scrollView
            .contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
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
