//
//  CustomNavigationHeaderView.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit


protocol CustomNavigationHeaderViewDelegate : AnyObject {
    func onClickBack()
    func setHeaderTitle() -> String
}

class CustomNavigationHeaderView: UIView {


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
    
    
    @IBOutlet private weak var lblTitle: ManropeMediumLabel!
    
    weak var delegate: CustomNavigationHeaderViewDelegate? {
        didSet{
            let title = delegate?.setHeaderTitle() ?? "Title"
            setHeaderTitle(title)
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomShadow()
    }
    
    private func setupUI() {
        // initial UI config

    }

    
    func setHeaderTitle(_ title: String) {
        lblTitle.text = title
    }
    
    @IBAction private func onClickBtnBack(_ sender: UIButton) {
        delegate?.onClickBack()
        Logger.log(#function)
    }
    

}
