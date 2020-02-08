import UIKit
import Firebase

class QRImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var amounLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var amount:Int = 0
    var currency:String = ""
    var category:String = ""
    var string:String = ""
    var processedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amounLabel.text = "\(amount)"
        currencyLabel.text = currency
        categoryLabel.text = category
        self.title = "QR Image"
        self.navigationController?.isNavigationBarHidden = false
        self.string = "[{\"amount\":\"\(amount)\",\"currency\":\"\(currency)\",\"type\":\"\(category)\",\"to\":\"\(Auth.auth().currentUser!.displayName!)\",\"toUID\":\"\(Auth.auth().currentUser!.uid)\"}]"
        let data = string.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return }
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return }
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return }
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return }
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: outputCIImage.extent) else { return }
        processedImage = UIImage(cgImage: cgImage)
        image.image = processedImage
    }
    
    @IBAction func toQR(_ sender: Any) {
        self.performSegue(withIdentifier: "QRGtoQR", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QRGtoQR"){
            let QRV = segue.destination as! QRViewController
            QRV.qrString = string
            QRV.QRImage = processedImage
        }
    }
}
