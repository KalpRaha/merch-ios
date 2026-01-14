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
        showWithAnimation()
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
