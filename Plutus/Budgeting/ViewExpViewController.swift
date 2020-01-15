//
//  ViewExpViewController.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 6/1/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class ViewExpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var expenditures: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = tableView.frame.height / 10.5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath)
        
        cell.textLabel?.text = "testing"
        cell.detailTextLabel?.text = "details"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
