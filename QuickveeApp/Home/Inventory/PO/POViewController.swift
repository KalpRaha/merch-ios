//
//  POViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 25/07/25.
//

import UIKit

class POListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var polist = [PO]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableview.isHidden = true
        loadingIndicator.isHidden = true
        setUpApi()
    }
    
    func setUpApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getPOList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                if let data = responseData["result"], (data as! [[String:Any]]).count != 0   {
                    
                    self.getResponseValues(list: data)
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.isAnimating = false
                        self.tableview.isHidden = false
                        self.tableview.reloadData()
                    }
                }
                else {
                    print("Api Error")
                }
            }
            else {
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(list: Any) {
        
        var small = [PO]()
        let response = list as! [[String: Any]]
                
        for po in response {
            
            let po = PO(vendor_name: "\(po["vendor_name"] ?? "")", id: "\(po["id"] ?? "")", po_number: "\(po["po_number"] ?? "")",
                        vendor_id: "\(po["vendor_id"] ?? "")", reference: "\(po["reference"] ?? "")", email: "\(po["email"] ?? "")",
                        issued_date: "\(po["issued_date"] ?? "")", stock_date: "\(po["stock_date"] ?? "")", received_status: "\(po["received_status"] ?? "")",
                        is_void: "\(po["is_void"] ?? "")", is_draft: "\(po["is_draft"] ?? "")", is_deleted: "\(po["is_deleted"] ?? "")",
                        received_at: "\(po["received_at"] ?? "")", created_at: "\(po["created_at"] ?? "")", updated_at: "\(po["updated_at"] ?? "")",
                        merchant_id: "\(po["merchant_id"] ?? "")", total_qty: "\(po["total_qty"] ?? "")", total_cost: "\(po["total_cost"] ?? "")")
            
            small.append(po)
        }
        
        polist = small
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toAddPO", sender: nil)
    }
}

extension POListViewController {
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

extension POListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! POTableViewCell
        
        let name = polist[indexPath.row].vendor_name
        let number = polist[indexPath.row].po_number
        
        cell.poName.text = "\(name) - \(number)"
        cell.poStatus.text = polist[indexPath.row].received_status
        
        cell.qtyValue.text = polist[indexPath.row].total_qty
        cell.costValue.text = polist[indexPath.row].total_cost
        cell.dueDateValue.text = polist[indexPath.row].received_at
        cell.updatedValue.text = polist[indexPath.row].updated_at
        cell.receivedValue.text = polist[indexPath.row].received_at
        
        cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.cornerRadius = 10
        
        return cell
    }
}

struct PO {
    
    let vendor_name: String
    let id: String
    let po_number: String
    let vendor_id: String
    let reference: String
    let email: String
    let issued_date: String
    let stock_date: String
    let received_status: String
    let is_void: String
    let is_draft: String
    let is_deleted: String
    let received_at: String
    let created_at: String
    let updated_at: String
    let merchant_id: String
    let total_qty: String
    let total_cost: String
}
