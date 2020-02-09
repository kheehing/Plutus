//
//  SavingPickerViewController.swift
//  Plutus
//
//  Created by ITP312 on 6/12/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit

class SavingPickerViewController: UIViewController, UITableViewDataSource {

    var pickerData : [String] = [
        "Daily",
        "Weekly",
        "Monthly"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextbtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        alert(title: "Alert", message: "Amount will be deducted when saved")
    }
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        navigationItem.backBarButtonItem = backItem
        
        if segue.destination is SavingInputViewController {
            let vc = segue.destination as? SavingInputViewController
            
            let selectedRow = tableView.indexPathForSelectedRow
            
            if selectedRow != nil {
                vc?.pickedDate = selectedRow!.row
            }
            
        }
    }
    
    @IBAction func moveToNextPage(_ sender: Any) {
        let selectedRow = tableView.indexPathForSelectedRow
        if selectedRow != nil {
            self.performSegue(withIdentifier: "getpickerdate", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = pickerData[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        // header title
        return "Options"
    }
    

}
