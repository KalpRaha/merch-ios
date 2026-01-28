//
//  ToastView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 31/12/25.
//

import UIKit

class ToastView: UIView {

    
    @IBOutlet private weak var vwToastSuperView: UIView!
    @IBOutlet private weak var lblMessage : UILabel!

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup
    private func commonInit() {
        loadNib()
        setupUI()
    }
    
    private func setupUI() {
        // initial UI config
        self.isUserInteractionEnabled = false
        vwToastSuperView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        vwToastSuperView.layer.cornerRadius = 6
        
        lblMessage.font = FontFamily.ManropeSemiBold.size(15)
        lblMessage.numberOfLines = 0
    }

    func setMessgae(_ message: String) {
        lblMessage.text = message
    }
    
}
