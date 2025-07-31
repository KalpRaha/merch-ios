//
//  VendorsViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 25/07/25.
//

import UIKit
import Alamofire

class VendorsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noVendorImage: UIImageView!
    @IBOutlet weak var noVendorLbl: UILabel!
    
    
    var vendorsArray = [VendorModel]()
    var subVendorArray = [VendorModel]()
    var vendorObj: VendorModel?
    
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        setupUI()
       
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VendorApiCall()
    }
    
    
    func VendorApiCall() {
       
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""

        tableView.isHidden = true
        loadIndicator.isAnimating = true
        noVendorLbl.isHidden = true
        noVendorImage.isHidden = true
        
        
        ApiCalls.sharedCall.getVendorList(merchant_id: id){ isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    self.loadIndicator.isAnimating = false
                    self.noVendorLbl.isHidden = false
                    self.noVendorImage.isHidden = false
                    return
                }
                self.getResponseValues(list: list)
                self.loadIndicator.isAnimating = false
            }
            else {
                
            }
            
            
        }
        
    }
 
    
    func getResponseValues(list: Any) {
        
        let response = list as! [[String: Any]]
    
        var small = [VendorModel]()
        
        for res in response {
            
            let vendor = VendorModel(vendor_id: "\(res["vendor_id"] ?? "")",
                                     name: "\(res["name"] ?? "")",
                                     phone:"\(res["phone"] ?? "")" ,
                                     email: "\(res["email"] ?? "")",
                                     city: "\(res["city"] ?? "")",
                                     state: "\(res["state"] ?? "")",
                                     zip_code: "\(res["zip_code"] ?? "")",
                                     full_address: "\(res["full_address"] ?? "")",
                                     pay_count: "\(res["pay_count"] ?? "")",
                                     total_pay: "\(res["total_pay"] ?? "")",
                                     recent_pay_amount: "\(res["recent_pay_amount"] ?? "")",
                                     recent_payment_datetime: "\(res["recent_payment_datetime"] ?? "")",
                                     enabled: "\(res["enabled"] ?? "")")
            
           
            vendorObj = vendor
            small.append(vendor)
        }
        
        if small.count == 0 {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
        }
        vendorsArray = small
        tableView.reloadData()
        
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddVendor" {
            
            
        }
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddVendor", sender: nil)
    }
    
   
    
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}

extension VendorsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorsArray.count
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
        
        print(vendorsArray[indexPath.row].name)
        cell.vendorName.text = vendorsArray[indexPath.row].name
        cell.payCount.text = "#\(vendorsArray[indexPath.row].pay_count)"
      
        
        if vendorsArray[indexPath.row].recent_payment_datetime == ""  {
            cell.paymentDateTime.text = "-"
        }
        else {
            cell.paymentDateTime.text = vendorsArray[indexPath.row].recent_payment_datetime
        }
        
        if vendorsArray[indexPath.row].recent_pay_amount == ""  {
            cell.payAmount.text = "-"
        }
        else {
            cell.payAmount.text = vendorsArray[indexPath.row].recent_pay_amount
        }
            
       
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toVendordetails", sender: nil)

    }
}



struct VendorModel {
   
    let vendor_id : String
    let name: String
    let phone: String
    let email: String
    let city: String
    let state: String
    let zip_code: String
    let full_address: String
    let pay_count: String
    let total_pay: String
    let recent_pay_amount: String
    let recent_payment_datetime: String
    let enabled: String
    
   
    
}
