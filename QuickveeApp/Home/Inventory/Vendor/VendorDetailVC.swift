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
    
   
    
    @IBOutlet weak var nodataImage: UIImageView!
    
    @IBOutlet weak var nodataLbl: UILabel!
    
   
    @IBOutlet weak var dateamtView: UIView!
   
    @IBOutlet weak var bottomTotalView: UIView!
    
    var  vendor_id = ""
    var vendor_Pay = [Vendors_Payment]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(vendor_id)
        
        
        if UserDefaults.standard.integer(forKey: "vendorDateMode") == 10 {
            if UserDefaults.standard.integer(forKey: "vendorDate") == 1 {
                setDateTime()
            }
        }
        
        vendorPayApiCall()
    }
    
    
    func vendorPayApiCall() {
        
        tableView.isHidden = true
        nodataLbl.isHidden = true
        nodataImage.isHidden = true
        dateamtView.isHidden = true
        bottomTotalView.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let sdate = UserDefaults.standard.string(forKey: "vendor_start_date")!
        let edate = UserDefaults.standard.string(forKey: "vendor_end_date")!
        
        print(sdate)
        print(edate)
        
        ApiCalls.sharedCall.VendorPayApi(merchant_id: id, vendor_id: vendor_id, start_date_time: sdate, end_date_time: edate) { isSuccess,responseData  in
            
            
            if isSuccess {
               
                guard let list = responseData["result"] else {
                    self.tableView.isHidden = true
                    self.nodataLbl.isHidden = false
                    self.nodataImage.isHidden = false
                    self.nodataLbl.text = "No Data Found"
                    self.dateamtView.isHidden = true
                    self.bottomTotalView.isHidden = true
                    
                    return
                }
                self.getresponseValuesPay(responseValues: list)
            }
            else {
                
            }
        }
    }
    
    func getresponseValuesPay(responseValues: Any) {
        
        let response = responseValues as! [[String:Any]]
        var vp = [Vendors_Payment]()
        
        for res in response {
            
            let vendor_pay = Vendors_Payment(id: "\(res["id"] ?? "")",
                                             vendor_id: "\(res["vendor_id"] ?? "")",
                                             merchant_id: "\(res["merchant_id"] ?? "")",
                                             pay_amount: "\(res["pay_amount"] ?? "")",
                                             payment_datetime: "\(res["payment_datetime"] ?? "")",
                                             updated_datetime: "\(res["updated_datetime"] ?? "")",
                                             is_deleted: "\(res["is_deleted"] ?? "")",
                                             remark: "\(res["remark"] ?? "")",
                                             pay_by: "\(res["pay_by"] ?? "")",
                                             employee_id: "\(res["employee_id"] ?? "")",
                                             shift_setting: "\(res["shift_setting"] ?? "")")
            
            vp.append(vendor_pay)
        }
        
        if vp.count == 0 {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
            dateamtView.isHidden = false
        }
        
        vendor_Pay = vp
        tableView.reloadData()
    }
    

    
    func setDateTime() {
        
        let date = Date()
        
       
        
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateFormat = "yyyy-MM-dd H:m:s"
        
        let currentDateTimeString = df.string(from: date)
        print("Current Date and Time: \(currentDateTimeString)")

        // Date-only formatter
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.timeZone = TimeZone.current
        dateOnlyFormatter.dateFormat = "yyyy-MM-dd"

        let dateOnlyString = dateOnlyFormatter.string(from: date)
        let startDate = "\(dateOnlyString) 00:00:00"
        let endDate = "\(dateOnlyString) 23:59:59"

        print("Start of Day: \(startDate)")
        print("End of Day: \(endDate)")
        
        UserDefaults.standard.set(startDate, forKey: "vendor_start_date")
        UserDefaults.standard.set(endDate, forKey: "vendor_end_date")
    }
  
    

    @IBAction func filterBtnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "toVendorFilter", sender: nil)
        
    }
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func homeBtnClick(_ sender: Any) {
        
    }
}

extension VendorDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendor_Pay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorDetailCell") as! VendorDetailCell
        
        print(vendor_Pay[indexPath.row].payment_datetime)
        
        let toast = ToastClass()
        let payDate = toast.setStockDateFormat(dateStr: vendor_Pay[indexPath.row].payment_datetime)
        
        
        cell.dateLbl.text = payDate
        cell.amtLbl.text = "$\(vendor_Pay[indexPath.row].pay_amount)"
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = UIColor(hexString: "#F9F9F9")
        }
        
        return cell
    }
}

struct Vendors_Payment {
    
    let id: String
    let vendor_id: String
    let merchant_id: String
    let pay_amount: String
    let payment_datetime: String
    let updated_datetime: String
    let is_deleted: String
    let remark:String
    let pay_by: String
    let employee_id: String
    let shift_setting: String
    
    
}
