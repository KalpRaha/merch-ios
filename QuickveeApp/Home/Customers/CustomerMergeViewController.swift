//
//  CustomerMergeViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 29/08/25.
//

import UIKit

class CustomerMergeViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var initialName: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var mergeBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    
    var custObj: FindCustModel?
    
    var customerList = [CustomersModel]()
    var subCustomerListArray = [CustomersModel]()
    var searchCustomerListArray = [CustomersModel]()
    
    var searching = false
    
    var secondary_cust_Id = ""
    var primary_cust_Id = ""
    
    var secondaryEmail = ""
    
    
    var isSelect = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        profileView.layer.cornerRadius = 23
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        mergeBtn.layer.cornerRadius = 5
        topView.addBottomShadow()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setdata( )
        mergeCustomerslistAPI()
        
    }
   
    func setdata() {
         
        let fName = custObj?.name ?? ""
        let emailid = custObj?.email ?? ""
        let phone_no = custObj?.phone ?? ""
        
        primary_cust_Id = custObj?.customer_id ?? ""
        customerName.text = fName
        phone.text = phone_no
        email.text = emailid
        let initials = getInitials(from:custObj?.f_name ?? "" )
        initialName.text = initials.uppercased()
        initialName.textColor = UIColor(named: "SelectCat")

    }
    
    func mergeCustomerslistAPI() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let group_id = UserDefaults.standard.string(forKey: "group_id") ?? ""
        
      
        ApiCalls.sharedCall.getMergeCustomers(merchant_id: id, page_no: 1, group_id: group_id) { isSuccess, responseData in
            
            if isSuccess {
                
                
                guard let list = responseData["result"] else {
                    print("no results")
                   
                    return
                }
                self.getResponseValues(list: list)
               
            }
            else {
                
            }
        }
        
        
    }
 
    func getResponseValues(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [CustomersModel]()
        
        for res in response {
            
            let customer = CustomersModel(customer_id: "\(res["customer_id"] ?? "")",
                                          name: "\(res["name"] ?? "")",
                                          email: "\(res["email"] ?? "")",
                                          phone: "\(res["phone"] ?? "")",
                                          a_address_line_1: "\(res["a_address_line_1"] ?? "")",
                                          suite: "\(res["suite"] ?? "")",
                                          pincode: "\(res["pincode"] ?? "")",
                                          state: "\(res["state"] ?? "")",
                                          city: "\(res["city"] ?? "")",
                                          dob: "\(res["dob"] ?? "")",
                                          note: "\(res["note"] ?? "")",
                                          is_disabled: "\(res["is_disabled"] ?? "")",
                                          total_bonus_points: "\(res["total_bonus_points"] ?? "")",
                                          total_store_credit: "\(res["total_store_credit"] ?? "")")
            
            
            if customer.customer_id == "null" {
                
            }
            else {
                small.append(customer)
            }
           
        }
        print(small)
        customerList = small
        subCustomerListArray = small
        tableView.reloadData()
        
    }
    
    
    func mergeCustAPiCall() {
        
        let primaryEmail = custObj?.email ?? ""
        
        guard  primaryEmail != secondaryEmail else {
            ToastClass.sharedToast.showToast(message: "Please Select Right Customer", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        let group_id = UserDefaults.standard.string(forKey: "group_id") ?? ""
        
        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.mergeCustomers(merchant_id: id, primary_customer_id: primary_cust_Id , secondary_customer_id: secondary_cust_Id, emp_id: emp_id, group_id: group_id){  isSuccess, responseData in
            
            if isSuccess {
                guard let list = responseData["message"] else {
                    print("no results")
                self.loadingIndicator.isAnimating = false
                   
                    return
                }
                //print(list)
               
                if list as! String == "Merchant ID, primary customer ID, and secondary customer ID are all required." {
                    self.loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Customer not found in list ", font: .systemFont(ofSize: 12))
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() +  1.0) {
                        self.loadingIndicator.isAnimating = false
                        self.secondary_cust_Id = ""
                        self.tableView.reloadData()
                    }
                    ToastClass.sharedToast.showToast(message: list as! String, font: .systemFont(ofSize: 12))
                    self.navigationController?.popViewController(animated: true)
                }
               
            }
            else {
                print("error")
            }
            
        }
        
    }
    
  
    func getInitials(from name: String) -> String {
        
        let nameComponents = name.split(separator: " ")
        let firstInitial = nameComponents.first?.prefix(1) ?? ""
        
        var middleInitial = ""
        if nameComponents.count > 2 {
            middleInitial = String(nameComponents[1].prefix(1))
        }
        
        let lastInitial = nameComponents.count > 1 ? nameComponents.last?.prefix(1) ?? "" : ""
        return "\(firstInitial)\(middleInitial)\(lastInitial)"
    }
  
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        else {
            searching = true
            searchCustomerListArray = subCustomerListArray.filter{ $0.name.lowercased().contains(searchText.lowercased())
                
            }
        }
        tableView.reloadData()
    }
    
    
    
    
    @IBAction func backBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
//        self.secondary_cust_Id = ""
//        self.tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mergeBtnClick(_ sender: UIButton) {
        mergeCustAPiCall()
    }
  
}

extension CustomerMergeViewController {
    
      private func setupUI() {
          
          if #available(iOS 13.0, *) {
              overrideUserInterfaceStyle = .light
          }
         
          mergeBtn.addSubview(loadingIndicator)
          
          NSLayoutConstraint.activate([
              loadingIndicator.centerXAnchor
                .constraint(equalTo: mergeBtn.centerXAnchor, constant: 40),
              loadingIndicator.centerYAnchor
                .constraint(equalTo: mergeBtn.centerYAnchor),
              loadingIndicator.widthAnchor
                  .constraint(equalToConstant: 15),
              loadingIndicator.heightAnchor
                  .constraint(equalTo: self.loadingIndicator.widthAnchor)
          ])
      
      }
}


extension CustomerMergeViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        searchBar.text = ""
        view.endEditing(true)
        performSearch(searchText: "")
    }
    
    
}

extension CustomerMergeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCustomerListArray.count
        }
        else {
            return customerList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if searching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerMergeTableViewCell", for: indexPath) as! CustomerMergeTableViewCell
            cell.bgView.layer.cornerRadius = 22
            cell.selectionStyle = .none
            
            
            cell.customerName.text = searchCustomerListArray[indexPath.row].name
            cell.phoneNumber.text = searchCustomerListArray[indexPath.row].phone
            cell.email.text = searchCustomerListArray[indexPath.row].email
            
            let initials = getInitials(from: customerList[indexPath.row].name)
            cell.initialName.text = initials.uppercased()
            
            
            if searchCustomerListArray[indexPath.row].customer_id == secondary_cust_Id {
                
                cell.radioBtn.setImage(UIImage(named: "green_select"), for: .normal)
                cell.initialName.textColor = UIColor(named: "SelectCat")
                cell.bgView.backgroundColor = UIColor(hexString: "#AECCFF")
                cell.customerName.textColor = UIColor.black
                cell.email.textColor = UIColor.black
                cell.phoneNumber.textColor = UIColor.black
                cell.emailImage.image = UIImage(named: "phoneblack")
                cell.phoneImage.image = UIImage(named: "emailblack")
                
            }
            else {
                cell.radioBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
                cell.initialName.textColor =  UIColor(hexString: "#818181")
                cell.bgView.backgroundColor = UIColor(hexString: "#E9E9E9")
                cell.customerName.textColor = UIColor(hexString: "#818181")
                cell.email.textColor =  UIColor(hexString: "#818181")
                cell.phoneNumber.textColor = UIColor(hexString: "#818181")
                cell.emailImage.image = UIImage(named: "phone_grey")
                cell.phoneImage.image = UIImage(named: "email_grey(5)")
            }
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerMergeTableViewCell", for: indexPath) as! CustomerMergeTableViewCell
            cell.bgView.layer.cornerRadius = 22
            cell.selectionStyle = .none
            
            
            cell.customerName.text = customerList[indexPath.row].name
            cell.phoneNumber.text = customerList[indexPath.row].phone
            cell.email.text = customerList[indexPath.row].email
            
            let initials = getInitials(from: customerList[indexPath.row].name)
            cell.initialName.text = initials.uppercased()
            
            
            if customerList[indexPath.row].customer_id == secondary_cust_Id {
                
                cell.radioBtn.setImage(UIImage(named: "green_select"), for: .normal)
                cell.initialName.textColor = UIColor(named: "SelectCat")
                cell.bgView.backgroundColor = UIColor(hexString: "#AECCFF")
                cell.customerName.textColor = UIColor.black
                cell.email.textColor = UIColor.black
                cell.phoneNumber.textColor = UIColor.black
                cell.emailImage.image = UIImage(named: "phoneblack")
                cell.phoneImage.image = UIImage(named: "emailblack")
                
            }
            else {
                cell.radioBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
                cell.initialName.textColor =  UIColor(hexString: "#818181")
                cell.bgView.backgroundColor = UIColor(hexString: "#E9E9E9")
                cell.customerName.textColor = UIColor(hexString: "#818181")
                cell.email.textColor =  UIColor(hexString: "#818181")
                cell.phoneNumber.textColor = UIColor(hexString: "#818181")
                cell.emailImage.image = UIImage(named: "phone_grey")
                cell.phoneImage.image = UIImage(named: "email_grey(5)")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            secondary_cust_Id = searchCustomerListArray[indexPath.row].customer_id
            secondaryEmail = searchCustomerListArray[indexPath.row].email
            print(secondary_cust_Id)
        
            tableView.reloadData()
        }
        else {
            secondary_cust_Id = customerList[indexPath.row].customer_id
            secondaryEmail = customerList[indexPath.row].email
            print(secondary_cust_Id)
        
            tableView.reloadData()
        }
        
    }
}

    
   
