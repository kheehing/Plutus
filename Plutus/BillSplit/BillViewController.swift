//
//  BillViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 14/1/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class BillViewController: UIViewController {
    
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var findTextButton: UIButton!
    
    var SelectedImage : UIImage!
    var textRecognizer : VisionTextRecognizer!
    var db : Firestore!
    var resultText : String!
    var listOfLines : [String] = []
    var receiptID : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView!.image = SelectedImage
        
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
        
        db = Firestore.firestore()
    }

    @IBAction func onFindTextButton(_ sender: Any) {
        runTextRecognition(with: SelectedImage)
        print("running find text button")
    }
    
    func runTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { (features, error) in
            guard error == nil, let features = features else {
                print("Text recognizer failed with error: \(String(describing: error))")
                return
            }
            var sum = 0
            for block in features.blocks{
                //print("block \(sum): \(block.text)")
                sum += 1
                for line in block.lines {
                    var sumline = 1
                    self.listOfLines.append(line.text)
                    print("line \(sumline): \(line.text)")
                    sumline += 1
                    for element in line.elements{
                        var sumelement = 1
                        //print("element \(sumelement): \(element.text)")
                        sumelement += 1
                    }
                }
            }
            self.resultText = features.text
            self.sendReceiptText()
            print(self.resultText)
            self.performSegue(withIdentifier: "productSegue", sender: self)
        }
    }
    
    private func sendReceiptText() {
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("receipt").addDocument(data: [
            "text" : listOfLines]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.receiptID = ref!.documentID
                }
        }
        self.receiptID = ref!.documentID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BillProductsViewController {
            let vc = segue.destination as? BillProductsViewController
            vc?.stringOfStrings = listOfLines
            vc?.receiptID = receiptID
        }
    }


}
