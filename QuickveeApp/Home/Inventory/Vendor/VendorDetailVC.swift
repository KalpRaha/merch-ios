//
//  VendorDetailVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 29/07/25.
//

import UIKit

class VendorDetailVC: UIViewController {

    @IBOutlet weak var titel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
    }
    

    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func homeBtnClick(_ sender: Any) {
        
    }
}

extension VendorDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorDetailCell") as! VendorDetailCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = UIColor(hexString: "#F9F9F9")
        }
        
        return cell
    }
}
