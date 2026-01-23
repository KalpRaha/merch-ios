//
//  ProductAndCategoriesPromotionConflictBottomSheetVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit

final class ProductAndCategoriesPromotionConflictBottomSheetVC: BaseBottomSheetVC, Navigatable {
    
    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    @IBOutlet private weak var _bgView: UIView!
    @IBOutlet private weak var _bottomContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction private func onClickBtnCross(_ sender: UIButton) {
        hideWithAnimation()
        Logger.log(#function)
    }
    
    @IBAction func onClickBtnCancel(_ sender: CustomButton) {
        hideWithAnimation()
        Logger.log(#function)
    }
    
    @IBAction func onClickContinue(_ sender: CustomButton) {
//        hideWithAnimation()
        Logger.log(#function)
    }
    
}

extension ProductAndCategoriesPromotionConflictBottomSheetVC : BaseBottomSheetVCActionDelegate  {
    
    func setBGTapView() -> UIView {
        _bgView
    }
    
    func setBottomContainerView() -> UIView {
        _bottomContainerView
    }

    
}
