//
//  PNCDPromotionConflictBottomSheetVC.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import UIKit

final class PNCDPromotionConflictBottomSheetVC: BaseBottomSheetVC, Navigatable {
    
    static var storyboard: UIStoryboard { .productAndCategoryDiscount }
    
    @IBOutlet private weak var _bgView: UIView!
    @IBOutlet private weak var _bottomContainerView: UIView!
    @IBOutlet private weak var radioButton1: UIButton!
    @IBOutlet private weak var radioButton2: UIButton!
    
    private var selectedOption: Int = 1 // 1 for override, 2 for do not override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupRadioButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupRadioButtons() {
        // Set initial state - option 1 selected by default
        radioButton1.setImage(UIImage(named: "select_radio"), for: .normal)
        radioButton2.setImage(UIImage(named: "unselect_radio"), for: .normal)
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
    
    @IBAction func onClickRadioOption1(_ sender: UIButton) {
        selectedOption = 1
        radioButton1.setImage(UIImage(named: "select_radio"), for: .normal)
        radioButton2.setImage(UIImage(named: "unselect_radio"), for: .normal)
        Logger.log(#function)
    }
    
    @IBAction func onClickRadioOption2(_ sender: UIButton) {
        selectedOption = 2
        radioButton1.setImage(UIImage(named: "unselect_radio"), for: .normal)
        radioButton2.setImage(UIImage(named: "select_radio"), for: .normal)
        Logger.log(#function)
    }
    
}

extension PNCDPromotionConflictBottomSheetVC : BaseBottomSheetVCActionDelegate  {
    
    func setBGTapView() -> UIView {
        _bgView
    }
    
    func setBottomContainerView() -> UIView {
        _bottomContainerView
    }

    
}
