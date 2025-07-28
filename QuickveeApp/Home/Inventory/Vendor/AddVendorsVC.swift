//
//  AddVendorsVC.swift
//  QuickveeApp
//
//  Created by Pallavi on 28/07/25.
//

import UIKit

class AddVendorsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addBottomShadow()
      
    }
   
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
    }
}
