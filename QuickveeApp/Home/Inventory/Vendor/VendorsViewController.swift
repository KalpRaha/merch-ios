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
    var searchVendorArray = [VendorModel]()
    
    
    
    var vendorID = ""
    var mode = ""
    var searching = false
    
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
        subVendorArray = []
        searching = false
        VendorApiCall()
    }
    
    
    func VendorApiCall() {
       
        
        loadIndicator.isAnimating = true
        tableView.isHidden = true
        noVendorLbl.isHidden = true
        noVendorImage.isHidden = true
        noVendorLbl.text = "No Vendor Found"
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""

     
        
        
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
            
           
            //vendorObj = vendor
            if vendor.vendor_id == "" {
                
            }
            else {
                small.append(vendor)
                
            }
            
        }
     
        
        if small.count == 0 {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
        }
        vendorsArray = small
        subVendorArray = small
        tableView.reloadData()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddVendor" {
            
            let vc = segue.destination as! AddVendorsVC
            
            if mode == "add" {
                vc.mode = "add"
            }
            else {
                vc.mode = "edit"
                vc.vendorObj = vendorObj
            }
        }
        else if segue.identifier == "toVendordetails" {
            let vc = segue.destination as! VendorDetailVC
            vc.vendor_id = vendorID
            vc.venor_obj = vendorObj
        }
    }
    
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            tableView.isHidden = false
            noVendorLbl.isHidden = true
            noVendorImage.isHidden = true
        }
        
        else {
            searching = true
            searchVendorArray = subVendorArray.filter { $0.name.lowercased().prefix(searchText.count) == searchText.lowercased()}
            
            
            if searchVendorArray.count == 0 {
                
                tableView.isHidden = true
                noVendorLbl.isHidden = false
                noVendorImage.isHidden = false
            }
            else {
                tableView.isHidden = false
                noVendorLbl.isHidden = true
                noVendorImage.isHidden = true
            }
        }
        tableView.reloadData()
    }
    
    @objc func editBtnClick(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
           let index = view.tag
       
        
        mode = "edit"
        vendorObj = vendorsArray[index]
        performSegue(withIdentifier: "toAddVendor", sender: nil)
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        mode = "add"
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
       
        if searching {
            return searchVendorArray.count
        }
        else {
            return vendorsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if searching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VendorsTableViewCell") as! VendorsTableViewCell
            
            
            
            cell.bgView.layer.cornerRadius = 5
            cell.bgView.clipsToBounds = true
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor(hexString: "#E5E5E5").cgColor
            
            cell.smallView.layer.borderWidth = 1
            cell.smallView.layer.borderColor = UIColor(hexString: "#DFE9FF").cgColor
            cell.smallView.layer.cornerRadius = 5
            
            cell.smallView.tag = indexPath.row
            let tap4 = UITapGestureRecognizer(target: self, action: #selector(editBtnClick))
            tap4.numberOfTapsRequired = 1
            cell.smallView.addGestureRecognizer(tap4)
            cell.smallView.isUserInteractionEnabled = true
            
            
            if searchVendorArray[indexPath.row].enabled == "1" {
                cell.vendorName.textColor = .black
                cell.payAmount.textColor = .black
                cell.paymentDateTime.textColor = .black
                cell.payCount.textColor = .black
                cell.disabledBtn.isHidden = true
                
            }
            else {
                cell.vendorName.textColor = .lightGray
                cell.payAmount.textColor = .lightGray
                cell.paymentDateTime.textColor = .lightGray
                cell.payCount.textColor = .lightGray
                cell.disabledBtn.isHidden = false
            }
            
            
            cell.vendorName.text = searchVendorArray[indexPath.row].name
            cell.payCount.text = "#\(searchVendorArray[indexPath.row].pay_count)"
            
            if searchVendorArray[indexPath.row].recent_payment_datetime == ""  {
                cell.paymentDateTime.text = "-"
            }
            else {
                let toast = ToastClass()
                let date = toast.setStockDateFormat(dateStr: searchVendorArray[indexPath.row].recent_payment_datetime)
                cell.paymentDateTime.text = "\(date)- $\(searchVendorArray[indexPath.row].recent_pay_amount)"
            }
            
            if searchVendorArray[indexPath.row].recent_pay_amount == ""  {
                cell.payAmount.text = "-"
            }
            else {
                cell.payAmount.text = "$\(searchVendorArray[indexPath.row].total_pay)"
            }
            return cell
        }
        else {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "VendorsTableViewCell") as! VendorsTableViewCell
            
            cell.bgView.layer.cornerRadius = 5
            cell.bgView.clipsToBounds = true
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor(hexString: "#E5E5E5").cgColor
            
            cell.smallView.layer.borderWidth = 1
            cell.smallView.layer.borderColor = UIColor(hexString: "#DFE9FF").cgColor
            cell.smallView.layer.cornerRadius = 5
            
            cell.smallView.tag = indexPath.row
            let tap4 = UITapGestureRecognizer(target: self, action: #selector(editBtnClick))
            tap4.numberOfTapsRequired = 1
            cell.smallView.addGestureRecognizer(tap4)
            cell.smallView.isUserInteractionEnabled = true
            
            if vendorsArray[indexPath.row].enabled == "1" {
                cell.vendorName.textColor = .black
                cell.payAmount.textColor = .black
                cell.paymentDateTime.textColor = .black
                cell.payCount.textColor = .black
                cell.disabledBtn.isHidden = true
                
            }
            else {
                cell.vendorName.textColor = .lightGray
                cell.payAmount.textColor = .lightGray
                cell.paymentDateTime.textColor = .lightGray
                cell.payCount.textColor = .lightGray
                cell.disabledBtn.isHidden = false
            }
            
            
            
            cell.vendorName.text = vendorsArray[indexPath.row].name
            cell.payCount.text = "#\(vendorsArray[indexPath.row].pay_count)"
            
            if vendorsArray[indexPath.row].recent_payment_datetime == ""  {
                cell.paymentDateTime.text = "-"
            }
            else {
                let toast = ToastClass()
                let date = toast.setStockDateFormat(dateStr: vendorsArray[indexPath.row].recent_payment_datetime)
                cell.paymentDateTime.text = "\(date)- $\(vendorsArray[indexPath.row].recent_pay_amount)"
            
            }
            
            if vendorsArray[indexPath.row].recent_pay_amount == ""  {
                cell.payAmount.text = "-"
            }
            else {
                cell.payAmount.text = "$\(vendorsArray[indexPath.row].total_pay)"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searching {
            
            if searchVendorArray[indexPath.row].enabled == "1" {
                performSegue(withIdentifier: "toVendordetails", sender: nil)
            }
            else {
                
            }
            
            vendorID = searchVendorArray[indexPath.row].vendor_id
            vendorObj = searchVendorArray[indexPath.row]
            
           
        }
        else {
            
            if vendorsArray[indexPath.row].enabled == "1" {
                performSegue(withIdentifier: "toVendordetails", sender: nil)
            }
            else {
                
            }
            vendorID = vendorsArray[indexPath.row].vendor_id
            vendorObj = vendorsArray[indexPath.row]
            print(vendorObj)
        }
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
