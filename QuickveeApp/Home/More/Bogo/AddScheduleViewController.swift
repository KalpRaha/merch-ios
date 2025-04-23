//
//  AddScheduleViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 22/04/25.
//

import UIKit
import MaterialComponents

class AddScheduleViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var startDateTextfield: MDCOutlinedTextField!
    
    
    @IBOutlet weak var endDateTextfield: MDCOutlinedTextField!
    @IBOutlet weak var startTimeTextfield: MDCOutlinedTextField!
    
    @IBOutlet weak var endTimeTextfield: MDCOutlinedTextField!
    
    
    
    @IBOutlet weak var noEndDateSwitch: UISwitch!
    @IBOutlet weak var fullDaySwitch: UISwitch!
    @IBOutlet weak var donotRepeatSwitch: UISwitch!
    @IBOutlet weak var fullDayStack: UIStackView!
    @IBOutlet weak var fulldayHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    var arrOfDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    func setUI() {
        
        createCustomTextField(textField: startDateTextfield)
        createCustomTextField(textField: endDateTextfield)
        createCustomTextField(textField: startTimeTextfield)
        createCustomTextField(textField: endTimeTextfield)
        
        startDateTextfield.label.text = "Start Date"
        endDateTextfield.label.text = "End Date"
        startTimeTextfield.label.text = "Start Time"
        endTimeTextfield.label.text = "End Time"
        
        
        startDateTextfield.delegate = self
        endDateTextfield.delegate = self
        startTimeTextfield.delegate = self
        endTimeTextfield.delegate = self
        
        noEndDateSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        fullDaySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        donotRepeatSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        let startDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        startDateImage.image = UIImage(named: "date_picker")
        startDateTextfield.trailingView = startDateImage
        startDateTextfield.trailingViewMode = .always
        
        
        let endDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        endDateImage.image = UIImage(named: "date_picker")
        endDateTextfield.trailingView = endDateImage
        endDateTextfield.trailingViewMode = .always
        
        
        
        
        let startTimeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        startTimeImage.image = UIImage(named: "time_picker")
        startTimeTextfield.trailingView = startTimeImage
        startTimeTextfield.trailingViewMode = .always
        
        let endTimeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        endTimeImage.image = UIImage(named: "time_picker")
        endTimeTextfield.trailingView = endTimeImage
        endTimeTextfield.trailingViewMode = .always
        
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        addBtn.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func backbtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @IBAction func noEndDateSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            sender.thumbTintColor = .systemBlue
            CustomendDateTextField(textField: endDateTextfield)
            endDateTextfield.isUserInteractionEnabled = false
            endDateTextfield.trailingView?.alpha = 0.1
        }
        else {
            createCustomTextField(textField: endDateTextfield)
            endDateTextfield.isUserInteractionEnabled = true
            endDateTextfield.trailingView?.alpha = 1
            sender.thumbTintColor = .white
        }
        
    }
    
    
    @IBAction func fullDaySwitchClick(_ sender: UISwitch) {
        
        if sender.isOn {
            sender.thumbTintColor = .systemBlue
            fulldayHeight.constant = 0
            fullDayStack.isHidden = true
            
        }
        else {
            sender.thumbTintColor = .white
            fulldayHeight.constant = 126
            fullDayStack.isHidden = false
            
        }
        
        
    }
    
    
    
    @IBAction func doNotRepeat(_ sender: UISwitch) {
        
        if sender.isOn {
            sender.thumbTintColor = .systemBlue
            collectionView.isHidden = true
            
        }
        else {
            
            sender.thumbTintColor = .white
            collectionView.isHidden = false
            
        }
        
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
    }
    
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    
    func CustomendDateTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .editing)
        textField.setNormalLabelColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setNormalLabelColor(UIColor(hexString: "#EBEBEB"), for : .editing)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .editing)
        textField.setFloatingLabelColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setFloatingLabelColor(UIColor(hexString: "#EBEBEB"), for : .editing)
    }
    
}

extension AddScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfDays.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daycell", for: indexPath) as! DayCollectionViewCell
        
        cell.checkImage.image = UIImage(named: "uncheck inventory")
        cell.dayLbl.text = arrOfDays[indexPath.row]
        return cell
    }
}

extension AddScheduleViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        return CGSize(width: width/5, height: 44)
    }
}
