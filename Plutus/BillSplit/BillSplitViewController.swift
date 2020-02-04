//
//  BillSplitViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 19/12/19.
//  Copyright © 2019 ITP312. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class BillSplitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var chosenImage : UIImage!

    @IBOutlet weak var photoOptions: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func photoOptionsAction(_ sender: Any) {
        // action sheet
        let photoMenu = UIAlertController(title: "Bill Split", message: nil, preferredStyle: .actionSheet)
        
        // create the actions
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .default)
        let selectPhotoAction = UIAlertAction(title: "Select a Photo", style: .default,
                                              handler: {action in self.selectPhoto()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // adding actions into controller
        photoMenu.addAction(takePhotoAction)
        photoMenu.addAction(selectPhotoAction)
        photoMenu.addAction(cancelAction)
        
        // display actions
        self.present(photoMenu, animated: true, completion: nil)
    }
    
    func selectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = info[.editedImage] as? UIImage
        //UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
        picker.dismiss(animated: true){
            self.performSegue(withIdentifier: "billSegue", sender: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BillViewController {
            let vc = segue.destination as? BillViewController
            vc?.SelectedImage = chosenImage
        }
    }
}
