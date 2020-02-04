//
//  BillProductsViewController.swift
//  Plutus(Local)
//
//  Created by ITP312 on 23/1/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class BillProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var stringOfStrings : [String] = []
    var receiptID : String = ""
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return stringOfStrings.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell.
        let cell : ProductCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCellTableViewCell
        cell.ProductLabel.text = stringOfStrings[indexPath.section]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowProductDetails"){
            let vc = segue.destination as! DetailsViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if(myIndexPath != nil){
                let product = stringOfStrings[(myIndexPath?.section)!]
                vc.pricing = product
            }
        }
        if(segue.identifier == "AddPeopleSegue"){
            let vc = segue.destination as! PeopleViewController
            vc.receiptID = receiptID
        }
    }
}
