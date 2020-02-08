import UIKit
import Foundation
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var image: UIImageView!
    
    var QRImage:UIImage!
    var qrString:String = ""
    var amount:Int = 0
    var currency:String = ""
    var type:String = ""
    var transferee:String = ""
    var transfereeUID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = false
        self.title = "Scan QR"
        image.image = QRImage
        let qrdata = qrString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: qrdata, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                amount = Int(jsonArray[0]["amount"]! as! String)!
                currency = jsonArray[0]["currency"]! as! String
                type = jsonArray[0]["type"]! as! String
                transferee = jsonArray[0]["to"]! as! String
                transfereeUID = jsonArray[0]["toUID"]! as! String
            } else {
                print("bad Json")
            }
        } catch let error as NSError {
            print("Json Error: \(error)")
        }
    }
    
    @IBAction func buttonOnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "toAfterScan", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAfterScan"){
            let afV = segue.destination as! AfterScanViewController
            afV.amount = amount
            afV.currency = currency
            afV.transferee = transferee
            afV.transfereeUID = transfereeUID
            afV.type = type
        }
    }
    
}
