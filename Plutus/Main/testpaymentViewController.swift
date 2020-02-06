//
//  testpaymentViewController.swift
//  Plutus
//
//  Created by ITP312 on 6/2/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import Braintree
class testpaymentViewController: UIViewController {

    var braintreeClient: BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        braintreeClient = BTAPIClient(authorization: "sandbox_w3ry6mkv_dqz5p667pcwdq44y")!
    }
    
    @IBAction func buttonOnClick(_ sender: Any) {
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest()
        request.billingAgreementDescription = "You agree to let Plutus withdraw money when you use the Plutus application to make payment." //Displayed in customer's PayPal account
        payPalDriver.requestBillingAgreement(request) { (tokenizedPayPalAccount, error) -> Void in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                // Send payment method nonce to your server to create a transaction
            } else if let error = error {
                print(error)
            } else {
                print("Buyer canceled payment approval")
            }
        }
    }
    //5505b1d1-3c17-0234-5d5c-bd73e55b3622
    @IBAction func getsomeMONEY(_ sender: Any){
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest()
        request.billingAgreementDescription = "ahahaha"
    }
}

extension testpaymentViewController : BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension testpaymentViewController : BTAppSwitchDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        //showLoadingUI()
        //NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        //hideLoadingUI()
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
    }
}
