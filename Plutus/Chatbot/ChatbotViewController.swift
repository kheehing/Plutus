//
//  ChatbotViewController.swift
//  Plutus
//
//  Created by Justin Tey on 16/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation
import FirebaseFirestore
import Firebase

class ChatbotViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var tableViewChat: UITableView!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var messages = [String]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
        let initializeMsg = "Welcome back, \(Auth.auth().currentUser?.displayName ?? "Anonymous")"
        self.reloadChatData(message: initializeMsg)
        self.speechAndText(text: initializeMsg)
        GlobalMsgCounter.counter = 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "botMsg", for: indexPath)
        // Showing and appending latest text based on input and response
        cell.textLabel?.text = messages[indexPath.row]
            
        return cell
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(false)
    }
    
    // Global counter for Default Welcome Intent
    struct GlobalMsgCounter {
        static var counter = 0
    }
    
    
    // Send message button pressed (arrow-like button)
    @IBAction func sendMessage(_ sender: Any) {
        //let request = ApiAI.shared().textRequest()
        let text = self.messageField.text
        
        if text != "" {
            //request?.query = text
            sendTextToBot(text!)
        }
        else {
            return
        }
        
//        request?.setMappedCompletionBlockSuccess({(request, response) in
//            let response = response as! AIResponse
//            if let textResponse = response.result.fulfillment.speech {
//                //self.speechAndText(text: textResponse)
//                self.responseToIntent(response, textResponse)
//                //self.reloadChatData(message: textResponse) // add this to responseToIntent for own customized response text
//            }
//        }, failure: {(request, error) in
//            print(error!)
//        })
        
        //ApiAI.shared().enqueue(request)
        messageField.text = ""
    }
    
    // Reload table view chat area
    func reloadChatData(message: String) {
        messages.append(message) // Appending latest message for table view
        tableViewChat.reloadData()
        tableViewChat.scrollToRow(at: IndexPath(item:messages.count-1, section: 0), at: .bottom, animated: true) // Scroll to the bottom of the table view
    }
    
    // Text to speech
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
    
    // Customized response based on Intent dectection
    func responseToIntent(_ response: AIResponse, _ textResponse: String) {
        let intent = response.result.metadata.intentName
        let entity = response.result.parameters!
        
        if intent != "" {
            print(intent!)
            var reply = textResponse // Dialog flow text response
            if intent == "Default Welcome Intent" {
                if GlobalMsgCounter.counter == 0 {
                    reply = "Welcome back, Afiq. \(textResponse)"
                    GlobalMsgCounter.counter = 1
                }
                self.reloadChatData(message: reply)
                self.speechAndText(text: reply)
            }
            else if intent == "Bill Split - yes - custom" {
                let unitCurrency = entity["unit-currency"] as! AIResponseParameter
                
                let phoneNumber = entity["phone-number"] as! AIResponseParameter
                
                var amt = unitCurrency.stringValue!
                if amt.count > 0 {
                    amt.remove(at: amt.startIndex)
                }
                
                print(amt)
                print(phoneNumber.stringValue!)
    
                self.reloadChatData(message: reply)
                self.speechAndText(text: reply)
                
                reply = "A total of $\(amt) has been billed to \(phoneNumber.stringValue!)"
                self.reloadChatData(message: reply)
                self.speechAndText(text: reply)
                
                
            }
            else if intent == "TransferAmt - custom" {
                let unitCurrency = entity["unit-currency"] as! AIResponseParameter
                
                let phoneNumber = entity["phone-number"] as! AIResponseParameter
                
                var amt = unitCurrency.stringValue!
                if amt.count > 0 {
                    amt.remove(at: amt.startIndex)
                }

                print(amt)
                print(phoneNumber.stringValue!)
                
                db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("balanceWallet").document("currency").getDocument{ (snapshot,err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let sData = snapshot!.data()!
                        let amountType = "sgd"
                        let amountBank = sData["\(amountType)"]!
                        let amountEntered:Int = Int(amt)!
                        let mobileNumber = phoneNumber.stringValue!
                        if (Int("\(amountBank)")! < Int(amountEntered)) {
                            //self.alert(title: "Invalid number", message: "Your bank doesn't have $\(amountEntered) \(amountType.uppercased()), \nit only has $\(amountBank) \(amountType.uppercased()).")
                            //
                            // ur bank does not have enough balanace, only have amoutBank balance
                            reply = "Your bank doesn't have $\(amountEntered) SGD, it only has $\(amountBank) SGD"
                            self.reloadChatData(message: reply)
                            self.speechAndText(text: reply)
                            
                        } else if ("+65\(mobileNumber)" == Auth.auth().currentUser!.phoneNumber!){
                            //self.alert(title: "Error", message: "you can not transfer money to yourself.")
                            //
                            // cannot xfer to self
                            reply = "You cannot transfer money to yourself!"
                            self.reloadChatData(message: reply)
                            self.speechAndText(text: reply)
                        } else {
                            self.db.collection("users").whereField("mobileNumber", isEqualTo: "+65\(mobileNumber)").getDocuments(){ (Tsnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    if (Tsnapshot!.isEmpty){
                                        //self.alert(title: "Invalid number", message: "the mobile number does not exist in out database, please check if you have entered the correct number.")
                                        //
                                        // invalid phone number
                                        reply = "The mobile number does not exist in our database, please check if you have entered the correct number."
                                        self.reloadChatData(message: reply)
                                        self.speechAndText(text: reply)
                                    } else {
                                        for document in Tsnapshot!.documents {
                                            self.db.collection("users").document(document.documentID).collection("balanceWallet").document("currency").getDocument{ (snapshott,err) in
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    
                                                    self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("balanceWallet").document("currency").updateData([ "sgd" : snapshot!.data()![amountType] as! Int - amountEntered ]) // transferer
                                                    
                                                    self.db.collection("users").document(document.documentID).collection("balanceWallet").document("currency").updateData([ "sgd" : snapshott!.data()![amountType] as! Int + amountEntered ]) // transferee
                                                    
                                                    self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("transaction").addDocument(data: [
                                                        "type": "transfer",
                                                        "transferer": Auth.auth().currentUser!.displayName!,
                                                        "transferee": "\(document.data()["firstName"]!) \(document.data()["lastName"]!)",
                                                        "time": Timestamp(date: Date()),
                                                        "amount": "\(amountEntered) \(amountType.uppercased())",]) // transferer
                                                    
                                                    self.db.collection("users").document(document.documentID).collection("transaction").addDocument(data: [
                                                        "type": "transfer",
                                                        "transferer": Auth.auth().currentUser!.displayName!,
                                                        "transferee": "\(document.data()["firstName"]!) \(document.data()["lastName"]!)",
                                                        "time": Timestamp(date: Date()),
                                                        "amount": "\(amountEntered) \(amountType.uppercased())",]) // transferee
                                                }
                                            }
                                        }
                                        self.reloadChatData(message: reply)
                                        self.speechAndText(text: reply)
                                        reply = "You have successfully transferred $\(amt) to \(phoneNumber.stringValue!)"
                                        self.reloadChatData(message: reply)
                                        self.speechAndText(text: reply)
                                    }
                                }
                            }
                        }
                    }
                }
                
//                self.reloadChatData(message: reply)
//                self.speechAndText(text: reply)
                
            }
            else {
                // Fallback response
                self.reloadChatData(message: textResponse)
                self.speechAndText(text: textResponse)
            }
            
        }
        
    }
    
    // Send desired message to the bot
    func sendTextToBot(_ userMsg: String) {
        let request = ApiAI.shared().textRequest()
        let text = userMsg
        
        if text != "" {
            request?.query = text
            reloadChatData(message: text)
        }
        else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({(request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.responseToIntent(response, textResponse)
                
            }
        }, failure: {(request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    // Quick Access Button To Send Quick Messages
    //
    @IBAction func greetingBtnPressed(_ sender: Any) {
        sendTextToBot("Hello")
    }
    
    @IBAction func budgetBtnPressed(_ sender: Any) {
        sendTextToBot("Transfer amount")
    }
    
    @IBAction func billSplitBtnPressed(_ sender: Any) {
        sendTextToBot("Bill split")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
