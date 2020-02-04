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

class ChatbotViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var tableViewChat: UITableView!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        
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
            else if intent == "Bill Split" {
                self.reloadChatData(message: reply)
                self.speechAndText(text: reply)
                
                // head to bill split page..?
            }
            else if intent == "Budgeting" {
                self.reloadChatData(message: reply)
                self.speechAndText(text: reply)
                
                // head to budgeting page..?
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
        sendTextToBot("Head to budgeting")
    }
    
    @IBAction func billSplitBtnPressed(_ sender: Any) {
        sendTextToBot("How to split my bill?")
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
