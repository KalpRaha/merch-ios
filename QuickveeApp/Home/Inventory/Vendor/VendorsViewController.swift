//
//  VendorsViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 25/07/25.
//

import UIKit

class VendorsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddVendor", sender: nil)
    }
    
}

extension VendorsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorsTableViewCell") as! VendorsTableViewCell
        
        cell.bgView.layer.cornerRadius = 5
        cell.bgView.clipsToBounds = true
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.borderColor = UIColor(hexString: "#E5E5E5").cgColor
        
        cell.smallView.layer.borderWidth = 1
        cell.smallView.layer.borderColor = UIColor(hexString: "#DFE9FF").cgColor
        cell.smallView.layer.cornerRadius = 5
        return cell
    }
    
    
}
