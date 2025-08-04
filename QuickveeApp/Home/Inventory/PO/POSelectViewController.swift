//
//  POSelectViewController.swift
//  QuickveeApp
//
//  Created by Kalpesh on 30/07/25.
//

import UIKit

class POSelectViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    var variantList = [InventoryVariant]()
    
    var searchVariantPOList = [VariantPOModel]()
    var searchSubVariantPOList = [VariantPOModel]()
    
    var variantPOList = [VariantPOModel]()
    var subVariantPOList = [VariantPOModel]()
    
    var categoryVariantList = [VariantPOModel]()
    
    var poSelectedVariants = [VariantPOModel]()
    
    var searching = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        topView.addBottomShadow()
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        variantListApi()
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                
                self.getResponseValues(variant: list)
                
                DispatchQueue.main.async {
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.tableview.reloadData()
                }
            }
            else {
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(variant: Any) {
        
        let response = variant as! [[String:Any]]
        
        var small = [InventoryVariant]()
        
        for res in response {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            if variant.is_lottery == "0" {
                small.append(variant)
            }
        }
        
        variantList = small
        setCheckVariants()
    }
    
    func setCheckVariants() {
        
        var miniSelect = poSelectedVariants
        
        for editvar in variantList {
            
            if editvar.isvarient == "1" {
                
                if poSelectedVariants.contains(where: {$0.po.var_id == editvar.var_id}) {
                }
                else {
                    miniSelect.append(VariantPOModel(po: editvar, isSelect: false))
                }
            }
            else {
                
                if poSelectedVariants.contains(where: {$0.po.id == editvar.id}) {
                }
                else {
                    miniSelect.append(VariantPOModel(po: editvar, isSelect: false))
                }
            }
            
            variantPOList = miniSelect
            subVariantPOList = miniSelect
            categoryVariantList = miniSelect
        }
    }
    
    func unSelectVarient(match: VariantPOModel) {
        
        if match.po.isvarient == "1" {
            poSelectedVariants.removeAll(where: {$0.po.var_id == match.po.var_id})
        }
        else {
            poSelectedVariants.removeAll(where: {$0.po.id == match.po.id})
        }
    }
    
    func selectSubVariant(match: VariantPOModel, offset: Bool) {
        
        
        if match.po.isvarient == "1" {
            
            let index = subVariantPOList.firstIndex(where: {$0.po.var_id == match.po.var_id}) ?? 0
            subVariantPOList[index].isSelect = offset
            
        }
        else {
            let index = subVariantPOList.firstIndex(where: {$0.po.id == match.po.id}) ?? 0
            subVariantPOList[index].isSelect = offset
        }
    }
    
    func selectSearchSubVariant(match: VariantPOModel, offset: Bool) {
        
        
        if match.po.isvarient == "1" {
            
            let index = searchSubVariantPOList.firstIndex(where: {$0.po.var_id == match.po.var_id}) ?? 0
            searchSubVariantPOList[index].isSelect = offset
            
        }
        else {
            
            let index = searchSubVariantPOList.firstIndex(where: {$0.po.id == match.po.id}) ?? 0
            searchSubVariantPOList[index].isSelect = offset
        }
    }
    
    func selectCategoryVariant(match: VariantPOModel, offset: Bool) {
        
        if match.po.isvarient == "1" {
            
            let index = categoryVariantList.firstIndex(where: {$0.po.var_id == match.po.var_id}) ?? 0
            categoryVariantList[index].isSelect = offset
            
        }
        else {
            let index = categoryVariantList.firstIndex(where: {$0.po.id == match.po.id}) ?? 0
            categoryVariantList[index].isSelect = offset
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ItemsPOViewController
        vc.poSelectedVariants = poSelectedVariants
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "toItemsPO", sender: nil)
    }
    
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

extension POSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        variantPOList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectBogoVariantCell
            
            let variant = searchVariantPOList[indexPath.row]
            
            if variant.po.isvarient == "1" {
                
                cell.varientLbl.isHidden = false
                let title = variant.po.title
                let variantName = variant.po.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                
                cell.priceLbl.text = "$ \(variant.po.var_price)"
                cell.upcLabel.text = variant.po.var_upc
                cell.varientLbl.text =  variant.po.variant
                
                let currentVarId = variant.po.var_id
                
                if variant.isSelect {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.var_id == currentVarId}) {
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                cell.varientLbl.isHidden = true
                cell.titleLbl.text = variant.po.title
                cell.priceLbl.text = "$\(variant.po.price)"
                cell.upcLabel.text = variant.po.upc
                
                let currentProdId = variant.po.id
                
                if variant.isSelect {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.id == currentProdId})  {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.contentView.backgroundColor = UIColor.white
            
            return cell
        }
        else {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectBogoVariantCell
            
            let variant = variantPOList[indexPath.row]
            
            if variant.po.isvarient == "1" {
                
                cell.varientLbl.isHidden = false
                
                let title = variant.po.title
                let variantName = variant.po.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                
                cell.priceLbl.text = "$\(variant.po.var_price)"
                cell.upcLabel.text = variant.po.var_upc
                cell.varientLbl.text =  variant.po.variant
                
                let currentVarId = variant.po.var_id
                
                if subVariantPOList[indexPath.row].isSelect {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.var_id == currentVarId}) {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                
                cell.titleLbl.text = variant.po.title
                cell.priceLbl.text = "$\(variant.po.price)"
                cell.upcLabel.text = variant.po.upc
                cell.varientLbl.isHidden = true
                
                let currentProdId = variant.po.id
                
                if subVariantPOList[indexPath.row].isSelect  {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else if poSelectedVariants.contains(where: {$0.po.id == currentProdId}) {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                }
            }
            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectBogoVariantCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = searchVariantPOList[indexPath.row]
            
            if  cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                cell.checkMarkImage.image = UIImage(named: "check inventory")
                
                variant.isSelect = true
                selectSubVariant(match: variant, offset: true)
                selectSearchSubVariant(match: variant, offset: true)
                selectCategoryVariant(match: variant, offset: true)
                poSelectedVariants.append(variant)
            }
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                selectSearchSubVariant(match: variant, offset: false)
                selectCategoryVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
            }
        }
        else {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectBogoVariantCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = variantPOList[indexPath.row]
            
            if  cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                cell.checkMarkImage.image = UIImage(named: "check inventory")
                
                variant.isSelect = true
                selectSubVariant(match: variant, offset: true)
                selectCategoryVariant(match: variant, offset: true)
                poSelectedVariants.append(variant)
            }
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                selectCategoryVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
            }
        }
    }
}
