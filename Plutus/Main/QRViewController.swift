import UIKit
import AVFoundation

class QRViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureSession = AVCaptureSession()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "QR"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() { }
        func configureCaptureDevices() throws { }
        func configureDeviceInputs() throws { }
        func configurePhotoOutput() throws { }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}
